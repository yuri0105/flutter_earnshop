import 'dart:async';
import 'dart:io';
import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/constants.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/layouts/RoundedButton.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

const String title = "FileUpload Sample app";
const String uploadURL = DEFAULT_HOST_URL + "/videos/video/";

class UploadItem {
  final String id;
  final String tag;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;

  UploadItem({
    this.id,
    this.tag,
    this.type,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,
  });

  UploadItem copyWith({UploadTaskStatus status, int progress}) => UploadItem(
      id: this.id,
      tag: this.tag,
      type: this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
      this.status == UploadTaskStatus.complete ||
      this.status == UploadTaskStatus.failed;
}

enum MediaType { Image, Video }

class UploadVideoScreen extends StatefulWidget {
  UploadVideoScreen({Key key}) : super(key: key);
  static final routeName = '/upload-video';
  String description;

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;
  Map<String, UploadItem> _tasks = {};
  String _title = "";
  String _description = "";
  String _token;
  final _form = GlobalKey<FormState>();
  var fileItem;
  var generatedFileItem;
  var url;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<File> _thumbnailImage = [];

  void _saveForm() {
    _form.currentState.save();
    getVideo(binary: false);
  }

  void generateThumbnail() async {}

  @override
  void initState() {
    super.initState();
    _progressSubscription = uploader.progress.listen((progress) {
      final task = _tasks[progress.tag];
      if (task == null) return;
      if (task.isCompleted()) return;
      setState(() {
        _tasks[progress.tag] =
            task.copyWith(progress: progress.progress, status: progress.status);
      });
    });
    _resultSubscription = uploader.result.listen((result) {
      final task = _tasks[result.tag];
      if (task == null) return;

      setState(() {
        _tasks[result.tag] = task.copyWith(status: result.status);
      });
    }, onError: (ex, stacktrace) {
      final exp = ex as UploadException;
      final task = _tasks[exp.tag];
      if (task == null) return;

      setState(() {
        _tasks[exp.tag] = task.copyWith(status: exp.status);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
  }

  void _pickThumbnailImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        this._thumbnailImage = [];
        this._thumbnailImage.add(image);
      });
      final String savedDir = dirname(_thumbnailImage[0].path);
      final String filename = basename(_thumbnailImage[0].path);
      generatedFileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "video_thumbnail",
      );
    } else {
      Fluttertoast.showToast(
        msg: "Please select a thumbnail image for the video!",
        timeInSecForIosWeb: 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _token = Provider.of<Auth>(context,listen: false).token;
    final DEVICE_SIZE = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Upload Video",
      ),
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: 20.0),
            Form(
              key: _form,
              child: Column(
                children: [
                  InkWell(
                    onTap: _pickThumbnailImage,
                    child: Container(
                      width: DEVICE_SIZE.width * 0.5,
                      height: DEVICE_SIZE.height * 0.15,
                      margin: EdgeInsets.only(bottom: 20),
                      // child: Center(child: Text("Upload Thumbnail")),
                      child: _thumbnailImage.length > 0
                          ? Image(image: FileImage(_thumbnailImage[0]))
                          : Center(child: Text("Upload Thumbnail")),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.elliptical(
                            DEVICE_SIZE.width * 0.05,
                            DEVICE_SIZE.height * 0.03)),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(fontSize: 20.0, color: Colors.grey),
                              labelText: "Title",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            onSaved: (value) => {
                              setState(() {
                                _title = value;
                              })
                            },
                          ),
                        ),
                        TextFormField(
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              labelText: "Description"),
                          onSaved: (value) => {
                            setState(() {
                              _description = value;
                            })
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, bottom: 50),
                    child: RaisedButton(
                      onPressed: () => _saveForm(),
                      child: Text("Select Video"),
                    ),
                  ),
                  RoundedButton(
                      label: "Upload Video",
                      onClick: () => uploadVideo(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _uploadUrl({bool binary}) {
    return uploadURL;
  }

  Future getVideo({@required bool binary}) async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final String savedDir = dirname(video.path);
      final String filename = basename(video.path);
      final tag = "${_title}";
      url = _uploadUrl(binary: binary);

      fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "video",
      );
    }
  }

  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: id);
  }

  void uploadVideo(context) async {
    if (fileItem == null) {
      Fluttertoast.showToast(
        msg: "Please select a select a video!",
        timeInSecForIosWeb: 3,
      );
      return;
    }
    if (generatedFileItem == null) {
      Fluttertoast.showToast(
        msg: "Please select a video thumbnail!",
        timeInSecForIosWeb: 3,
      );
      return;
    }
    var taskId = await uploader.enqueue(
        url: url,
        data: {
          "title": _title,
          "description": _description,
        },
        files: [fileItem, generatedFileItem],
        method: UploadMethod.POST,
        tag: _title,
        showNotification: true,
        headers: {
          "Authorization": "Token " + _token,
          "content-type": "multipart/form-data"
        });

    setState(() {
      _tasks.putIfAbsent(
          _title,
          () => UploadItem(
                id: taskId,
                tag: _title,
                type: MediaType.Video,
                status: UploadTaskStatus.enqueued,
              ));
    });

    Navigator.of(context).pop();
  }
}

typedef CancelUploadCallback = Future<void> Function(String id);

class UploadItemView extends StatelessWidget {
  final UploadItem item;
  final CancelUploadCallback onCancel;

  UploadItemView({
    Key key,
    this.item,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ? LinearProgressIndicator(value: progress)
        : Container();
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
            height: 50,
            width: 50,
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () => onCancel(item.id),
            ),
          )
        : Container();
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(item.tag),
              Container(
                height: 5.0,
              ),
              Text(item.status.description),
              Container(
                height: 5.0,
              ),
              widget
            ],
          ),
        ),
        buttonWidget
      ],
    );
  }
}
