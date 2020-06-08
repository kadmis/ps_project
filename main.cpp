#include "dehasher.h"
#include "deencryptor.h"
#include "helpers.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QQuickView>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QQuickStyle::setStyle("Material");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<Helpers>("helper",1,0,"Helpers");
    qmlRegisterType<DeEncryptor>("deencryptor",1,0,"DeEncryptor");

    Helpers helper;
    DeEncryptor deencryptor;
    engine.rootContext()->setContextProperty("helper", &helper);
    engine.rootContext()->setContextProperty("deencryptor", &deencryptor);    

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QObject *main = engine.rootObjects().first();
    QObject::connect(main, SIGNAL(startDeencryption(QString, QString, QString, bool)), &deencryptor, SLOT(startDeencryption(QString, QString, QString, bool)));

    return app.exec();
}
