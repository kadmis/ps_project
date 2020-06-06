#include "helpers.h"



QString Helpers::getFileNameFromPath(QString path) const
{
    return QFileInfo(path).fileName();
}

void Helpers::openDirectoryInExplorer(QString path)
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(path));
}
