#include "dehasher.h"

Result Dehasher::dehash(QString src, QString dst, QString password) const
{
    bool success=false;
    QString message="";

    wchar_t* sourceFileName=nullptr;
    wchar_t* destinationFileName=nullptr;
    wchar_t* pass=nullptr;

    src.toWCharArray(sourceFileName);
    dst.toWCharArray(destinationFileName);
    password.toWCharArray(pass);

    return Result(success,message);
}
