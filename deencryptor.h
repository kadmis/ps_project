#include "result.h"

#include <QString>
#include <Windows.h>
#include <wincrypt.h>
#include <stdio.h>
#include <QObject>
#include <QFuture>
#include <QtConcurrent/QtConcurrent>

#pragma comment(lib, "Crypt32.lib")
#pragma comment(lib, "advapi32")

#define AES_KEY_SIZE 16
#define CHUNK_SIZE (AES_KEY_SIZE*3)

#pragma once


class DeEncryptor : public QObject
{
    Q_OBJECT
    QFuture<Result> m_future;
    QFutureWatcher<Result> m_futureWatcher;

    static Result deencrypt(QString src, QString dst, QString password, bool isDecrypt);
    Q_SLOT void deencryptionTaskFinished()
    {
        Result result(m_future);
        emit deencryptionFinished(result.isSuccess(), result.getMessage());
    }
public:
    DeEncryptor()
    {
        connect(&m_futureWatcher, SIGNAL(finished()), SLOT(deencryptionTaskFinished()));
    }
    Q_SLOT void startDeencryption(QString src, QString dst, QString password, bool isDecrypt);
    Q_SIGNAL void deencryptionFinished(bool isSuccess, QString message);

};

