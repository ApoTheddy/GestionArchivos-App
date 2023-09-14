import 'package:flutter/material.dart';
import 'package:gfilesapp/UtilWidgets.dart';
import 'package:gfilesapp/components/NavBar.dart';
import 'package:gfilesapp/models/FileModel.dart';
import 'package:video_player/video_player.dart';

class VideoContentScreen extends StatefulWidget {
  const VideoContentScreen({
    Key? key,
    required this.file,
    required this.files,
  }) : super(key: key);

  final FileModel file;
  final ValueNotifier<List<FileModel>> files;

  @override
  _VideoContentScreenState createState() => _VideoContentScreenState();
}

class _VideoContentScreenState extends State<VideoContentScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.file.filepath));
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _initializeVideo() async {
    await _videoController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(0, 80),
          child: NavBar(title: widget.file.filename),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : Container(),
              ),
            ),
            InkWell(
              onTap: () {
                removeFile(context, widget.file.id, widget.files);
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 50,
                child: Center(child: Icon(Icons.delete)),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _videoController.value.isPlaying
                ? _videoController.pause()
                : _videoController.play();
            setState(() {});
          },
          child: Icon(
            _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
