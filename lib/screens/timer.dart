import 'package:flutter/material.dart';
import 'package:flutter_tasks/providers/time_provider.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int time = 300;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      TimeProvider timeProvider =
          Provider.of<TimeProvider>(context, listen: false);
      timeProvider.startTime(context);
    });
  }

  @override
  void deactivate() {
    TimeProvider timeProvider =
        Provider.of<TimeProvider>(context, listen: false);
    if (timeProvider.time != 0) {
      timeProvider.pauseTime();
    }
    super.deactivate();
  }
  //Dare format function

  String formatTime() {
    TimeProvider timeProvider =
        Provider.of<TimeProvider>(context, listen: false);

    int totalSeconds = timeProvider.time;
    int hour = totalSeconds ~/ (60 * 60);
    int min = (totalSeconds - (hour * 60 * 60)) ~/ 60;
    int sec = (totalSeconds - (hour * 60 * 60) - (min * 60));

    return "${hour.toString().length == 1 ? "0$hour" : hour} : ${min.toString().length == 1 ? "0$min" : min} : ${sec.toString().length == 1 ? "0$sec" : sec}";
  }

  @override
  Widget build(BuildContext context) {
    TimeProvider timeProvider = Provider.of<TimeProvider>(context);
    return Scaffold(
      backgroundColor: timeProvider.time < 60 ? Colors.red[800] : Colors.white,
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (timeProvider.time != 0) {
                  timeProvider.pauseTime();
                }
                await Navigator.pushNamed(context, "/weather");
              },
              child: const Text("Next"))
        ],
      ),
      body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                formatTime(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 56.0),
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: timeProvider.isStart
                          ? timeProvider.pauseTime
                          : () => timeProvider.startTime(context),
                      child: timeProvider.isStart
                          ? const Text("Pause")
                          : const Text("Resume")),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: timeProvider.resetTime,
                      child: const Text("Reset")),
                ],
              ),
            ],
          )),
    );
  }
}
