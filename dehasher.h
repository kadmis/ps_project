#include "result.h"

#include <QString>
#include <Windows.h>
#include <wincrypt.h>
#include <stdio.h>
#include <QObject>

#pragma comment(lib, "Crypt32.lib")
#pragma comment(lib, "advapi32")

#define AES_KEY_SIZE 16
#define CHUNK_SIZE (AES_KEY_SIZE*3)

#pragma once


class Dehasher: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE Result dehash(QString src, QString dst, QString password) const;
};

