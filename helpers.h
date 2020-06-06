#include <QObject>
#include <QString>
#include <QFileInfo>
#include <QDesktopServices>
#include <QUrl>

#pragma once


class Helpers : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE QString getFileNameFromPath(QString path) const;
    Q_INVOKABLE void openDirectoryInExplorer(QString path);
};

