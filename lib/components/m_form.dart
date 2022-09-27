part of flutter_muka;
/*
 * Summary: 表单
 * Created Date: 2022-09-26 23:47:05
 * Author: Spicely
 * -----
 * Last Modified: 2022-09-27 20:40:05
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

class MFormController {
  _MFormState? _state;

  /// 绑定状态
  void _bindTextState(_MFormState state) {
    _state = state;
  }

  void setValue(Map<String, dynamic> data) {
    // _state?.controllers.forEach((key, value) {
    //   if (data.containsKey(key)) {
    //     switch (value.controller.runtimeType) {
    //       case ITextEditingController:
    //         (value.controller as ITextEditingController).text = data[key];
    //         break;
    //       case GroupButtonController:
    //         List<MFormItemRadio> _data = value.props?.buttons ?? [];
    //         MFormItemRadio v = _data.firstWhere((v) => v.value == data[key], orElse: () => MFormItemRadio(label: '', value: null));
    //         (value.controller as GroupButtonController).selectIndex(_data.indexOf(v));
    //         break;
    //     }
    //   }
    // });
    if (_state?.controllers != null) {
      Map<String, _MFormMaps> maps = _state!.controllers;
      data.forEach((key, value) {
        if (maps.containsKey(key)) {
          switch (maps[key]?.controller.runtimeType) {
            case ITextEditingController:
              (maps[key]?.controller as ITextEditingController).text = value;
              break;
            case GroupButtonController:
              List<MFormItemRadio> _data = maps[key]?.props?.buttons ?? [];
              print(_data);
              MFormItemRadio v = _data.firstWhere((v) => v.value == value, orElse: () => MFormItemRadio(label: '', value: null));
              (maps[key]?.controller as GroupButtonController).selectIndex(_data.indexOf(v));
              break;
          }
        }
      });
      _state?.setState(() {});
    }
  }

  bool isVerify() {
    if (_state == null) return false;
    bool status = true;
    // for (var i in _state!.widget.children) {
    //   if (i.onChangedVerify != null && i.onChangedVerify!.call(_state!.controllers[i.field]!.text) != null) {
    //     status = false;
    //     break;
    //   }
    // }
    return status;
  }
}

class MForm extends StatefulWidget {
  final List<MFormItem> children;

  final MFormController? controller;

  final Function(String)? onChanged;

  final bool showError;

  final bool showDivider;

  final MukaFormTheme? config;

  const MForm({
    Key? key,
    required this.children,
    this.controller,
    this.onChanged,
    this.showError = false,
    this.showDivider = false,
    this.config,
  }) : super(key: key);

  @override
  State<MForm> createState() => _MFormState();
}

class _MFormMaps {
  final dynamic props;
  final dynamic controller;

  _MFormMaps({
    this.props,
    required this.controller,
  });
}

class _MFormState extends State<MForm> {
  Map<String, _MFormMaps> controllers = {};

  @override
  initState() {
    super.initState();
    widget.children.forEach((e) {
      switch (e.type) {
        case MFormItemType.textField:
          controllers[e.field] = _MFormMaps(
            props: e.textFieldProps,
            controller: ITextEditingController(text: e.initValue),
          );
          break;
        case MFormItemType.radio:
          List<MFormItemRadio> data = e.radioProps?.buttons ?? [];
          MFormItemRadio v = data.firstWhere((v) => v.value == e.initValue, orElse: () => MFormItemRadio(label: '', value: null));
          controllers[e.field] = _MFormMaps(
            props: e.radioProps,
            controller: GroupButtonController(selectedIndex: data.indexOf(v)),
          );
          break;
      }
    });
  }

  @override
  void didUpdateWidget(covariant MForm oldWidget) {
    widget.children.forEach((e) {
      if (controllers[e.field] == null) {
        switch (e.type) {
          case MFormItemType.textField:
            controllers[e.field] = _MFormMaps(
              props: e.textFieldProps,
              controller: ITextEditingController(text: e.initValue),
            );
            break;
          case MFormItemType.radio:
            List<MFormItemRadio> data = e.radioProps?.buttons ?? [];
            MFormItemRadio v = data.firstWhere((v) => v.value == e.initValue, orElse: () => MFormItemRadio(label: '', value: null));
            controllers[e.field] = _MFormMaps(
              props: e.radioProps,
              controller: GroupButtonController(selectedIndex: data.indexOf(v)),
            );
            break;
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller?._bindTextState(this);
  }

  @override
  Widget build(BuildContext context) {
    MukaFormTheme _formTheme = MukaConfig.config.formTheme;
    return Column(
      children: widget.children
          .map(
            (e) => ListItem(
              height: e.height ?? widget.config?.height ?? _formTheme.height,
              contentPadding: widget.config?.contentPadding ?? _formTheme.contentPadding ?? EdgeInsets.symmetric(horizontal: 15),
              color: widget.config?.background ?? _formTheme.background,
              title: SizedBox(
                width: e.config?.titleWidth ?? widget.config?.titleWidth ?? _formTheme.titleWidth,
                child: Text(e.title ?? ''),
              ),
              valueAlignment: e.type == MFormItemType.radio ? Alignment.centerRight : Alignment.centerRight,
              showArrow: e.showArrow ?? false,
              showDivider: e.showDivider ?? widget.showDivider,
              value: getValueView(e, _formTheme),
            ),
          )
          .toList(),
    );
  }

  Widget? getValueView(MFormItem e, MukaFormTheme theme) {
    switch (e.type) {
      case MFormItemType.textField:
        return ITextField(
          controller: controllers[e.field]!.controller,
          hintText: e.textFieldProps?.hintText,
          // textStyle: TextStyle(fontSize: 12),
          maxLines: e.textFieldProps?.maxLines ?? 1,
          contentPadding: EdgeInsets.zero,
          onChanged: (v) {
            String? err = e.textFieldProps?.onChangedVerify?.call(v);
            widget.onChanged?.call(v);
            if (err != null) {
              controllers[e.field]?.controller.showError(err);
            } else {
              controllers[e.field]?.controller.clearError();
            }
          },
        );
      case MFormItemType.radio:
        return GroupButton<MFormItemRadio>(
          controller: controllers[e.field]?.controller,
          isRadio: true,
          buttons: e.radioProps?.buttons ?? [],
          buttonBuilder: (selected, value, context) => GestureDetector(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio(
                  value: selected,
                  groupValue: true,
                  onChanged: (v) {
                    (controllers[e.field]?.controller as GroupButtonController).selectIndex((e.radioProps?.buttons ?? []).indexOf(value));
                  },
                ),
                Text(value.label),
              ],
            ),
            onTap: () {
              (controllers[e.field]?.controller as GroupButtonController).selectIndex((e.radioProps?.buttons ?? []).indexOf(value));
            },
          ),
        );
      default:
        return null;
    }
  }
}

enum MFormItemType {
  textField,

  radio,
}

class MFormItemRadio {
  final String label;

  final dynamic value;

  MFormItemRadio({
    required this.label,
    required this.value,
  });
}

class MFormRadioProps {
  final List<MFormItemRadio> buttons;

  MFormRadioProps({
    required this.buttons,
  });
}

class MFormItem {
  final String field;

  final dynamic initValue;

  final double? height;

  final String? title;

  final bool? showArrow;

  final bool? showDivider;

  final MFormItemType type;

  final MukaFormTheme? config;

  final MFormItemTextFieldProps? textFieldProps;

  final MFormRadioProps? radioProps;

  MFormItem({
    required this.field,
    this.config,
    this.height,
    this.initValue = '',
    this.showArrow,
    this.showDivider,
    this.title,
    this.type = MFormItemType.textField,
    this.textFieldProps,
    this.radioProps,
  });
}

class MFormItemTextFieldProps {
  final bool showDeleteIcon;

  final String? labelText;

  final bool readOnly;

  final TextAlign textAlign;

  /// 显示最大长度
  final bool isCount;

  final String? hintText;

  /// 输入验证
  final String? Function(String)? onChangedVerify;

  final int? maxLines;

  MFormItemTextFieldProps({
    this.showDeleteIcon = true,
    this.labelText,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.isCount = false,
    this.hintText,
    this.onChangedVerify,
    this.maxLines,
  });
}
