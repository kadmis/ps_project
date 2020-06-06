#include "result.h"

Result::Result(const Result & result)
{
    this->success = result.success;
    this->message = result.message;
}

Q_INVOKABLE QString Result::getMessage() const
{
    return this->message;
}

Q_INVOKABLE bool Result::isSuccess() const
{
    return this->success;
}

Q_INVOKABLE void Result::copyValues(const Result&object)
{
    this->success = object.success;
    this->message = object.message;
}


Q_INVOKABLE Result& Result::operator=(const Result&object)
{
    if(this==&object)
        return *this;

    message = object.message;
    success = object.success;

    return *this;
}
