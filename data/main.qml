import QtQuick 2.4
import QtQuick.Window 2.2
import QtMultimedia 5.6
import TensorFlow 1.0

Window {
    visible: true
    width: 650
    height: 400
    color: "#CDCDCD"
    
    TensorFlow {
        id: tensorflow
    }

    Camera {
        id: camera
        Component.onCompleted: {
            if (QtMultimedia.defaultCamera.displayName === "Intel RealSense 3D Camera LR200")
                camera.deviceId = QtMultimedia.availableCameras[2].deviceId;
        }
    }

    VideoOutput {
        source: camera
        focus : visible
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        } 
        width: parent.width * 3/5 
    }

    Text {
        id: result
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 20
        }
        font.bold: true
        font.pointSize: 20
        width: parent.width *2/5  - 50
    }

    Timer {
        id: timer
        interval: 300
        running: false
        repeat: false
        onTriggered: {
            var label = tensorflow.run("/tmp/test.jpg");
            result.text = label
            console.log(label);
            timer.running = false;
            camera.start()
        }
    }

    Rectangle {
        width: parent.width * 2/5 - 20
        height: 70
        radius: 5
        color: "#5D5D5D"
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 10
            bottomMargin: 25
        }
        Text {
            anchors.centerIn: parent
            text: "Label Me"
            color: "white"
            font.pointSize: 15
        }
    }

    MouseArea {
        anchors.fill: parent 
        onClicked: {
            camera.imageCapture.captureToLocation("/tmp/test.jpg");
            camera.stop()
            result.text = "Analyzing.." 
            timer.running = true;
        }
    }
}
