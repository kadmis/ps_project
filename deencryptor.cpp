#include "deencryptor.h"

Q_INVOKABLE Result DeEncryptor::deencrypt(QString src, QString dst, QString password, bool isDecrypt) const
{
    src = src.remove(0,8);
    LPCWSTR sourceFileName = _wcsdup(src.toStdWString().c_str());
    LPCWSTR destinationFileName = _wcsdup(dst.toStdWString().c_str());
    LPCWSTR pass = _wcsdup(password.toStdWString().c_str());

    size_t len = lstrlenW(pass);

    HANDLE hInpFile = CreateFileW(sourceFileName, GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, nullptr);
    if (hInpFile == INVALID_HANDLE_VALUE)
    {
        return Result(false,"Nie można otworzyć pliku źródłowego");
    }

    HANDLE hOutFile = CreateFileW(destinationFileName, GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (hOutFile == INVALID_HANDLE_VALUE)
    {
        return Result(false,"Nie można utworzyć pliku docelowego");
    }

    wchar_t info[] = L"Microsoft Enhanced RSA and AES Cryptographic Provider";

    HCRYPTPROV hProv;

    if (!CryptAcquireContextW(&hProv, nullptr, info, PROV_RSA_AES, CRYPT_VERIFYCONTEXT))
    {
        CryptReleaseContext(hProv, 0);
        return Result(false,"Operacja nie powiodła się");
    }

    HCRYPTHASH hHash;
    if (!CryptCreateHash(hProv, CALG_SHA_256, 0, 0, &hHash))
    {
        CryptReleaseContext(hProv, 0);
        return Result(false,"Operacja nie powiodła się");
    }

    if (!CryptHashData(hHash, (BYTE*)pass, len, 0))
    {
        return Result(false,"Operacja nie powiodła się");
    }

    HCRYPTKEY hKey;
    if (!CryptDeriveKey(hProv, CALG_AES_256, hHash, 0, &hKey))
    {
        CryptReleaseContext(hProv, 0);
        return Result(false,"Operacja nie powiodła się");
    }

    const size_t chunk_size = CHUNK_SIZE;
    BYTE chunk[chunk_size] = { 0 };
    DWORD out_len = 0;

    BOOL isFinal = FALSE;
    DWORD readTotalSize = 0;

    DWORD inputSize = GetFileSize(hInpFile, NULL);

    while (ReadFile(hInpFile, chunk, chunk_size, &out_len, NULL))
    {
        if (0 == out_len)
        {
            break;
        }
        readTotalSize += out_len;
        if (readTotalSize == inputSize)
        {
            isFinal = TRUE;
        }

        if(isDecrypt)
        {
            if (!CryptDecrypt(hKey, NULL, isFinal, 0, chunk, &out_len))
            {
                return Result(false,"Operacja nie powiodła się");
            }
        }
        else
        {

            if (!CryptEncrypt(hKey, NULL, isFinal, 0, chunk, &out_len, chunk_size))
            {
                return Result(false,"Operacja nie powiodła się");
            }
        }

        DWORD written = 0;
        if (!WriteFile(hOutFile, chunk, out_len, &written, NULL))
        {
            return Result(false,"Operacja nie powiodła się");
        }
        memset(chunk, 0, chunk_size);
    }

    CryptReleaseContext(hProv, 0);
    CryptDestroyKey(hKey);
    CryptDestroyHash(hHash);

    CloseHandle(hInpFile);
    CloseHandle(hOutFile);

    if(isDecrypt)
    {
        return Result(true, "Poprawnie odszyfrowano plik");
    }
    else
    {
        return Result(true,"Poprawnie zaszyfrowano plik");
    }
}










