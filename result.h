#include <QObject>

#pragma once

class Result: public QObject
{
    Q_OBJECT
    bool success;
    QString message;

public:
    explicit Result(QObject *parent = nullptr){}
    Result(const Result&);
    Result(bool success, QString message):success(success),message(message){}

    Q_INVOKABLE void copyValues(const Result&object);

    Q_INVOKABLE QString getMessage() const;
    Q_INVOKABLE bool isSuccess() const;

    Q_INVOKABLE Result& operator=(const Result&object);
};

