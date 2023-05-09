/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Apr 23 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'answer_call_screen.dart';

class _CancelButton extends StatefulWidget {
  const _CancelButton();

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton> {
  String? callID;
  bool requestCancel = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallActionBloc, CallActionState>(
      listener: (context, state) {
        if (state is CallActionAnsweredSuccessfullyWithWaitingCaller) {
          callID = state.data.id;

          if (requestCancel) cancel();
        } else if (state is CallActionLoading &&
            state.type == CallActionType.answered) {
          callID = null;
        }
      },
      child: CancelCallButton(
        onPressed: () => setState(() {
          cancel();
        }),
        isLoading: requestCancel,
      ),
    );
  }

  void cancel() {
    AppSnackbar(context).showMessage(LocaleKeys.end_call.tr());
    CallActionBloc callActionBloc = context.read<CallActionBloc>();
    requestCancel = true;

    if (callID != null) {
      callActionBloc.add(CallActionEnded(callID!));
    }
  }
}

class _AnsweringCallText extends StatelessWidget {
  const _AnsweringCallText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      LocaleKeys.async_answering_call,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    ).tr();
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage(this.url);

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const SizedBox();
    } else {
      return CallBackgroundImage(url: url!);
    }
  }
}

class _NameText extends StatelessWidget {
  const _NameText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 30,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
