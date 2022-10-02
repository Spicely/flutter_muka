part of flutter_muka;
/*
 * Summary: 表单
 * Created Date: 2022-09-26 23:47:05
 * Author: Spicely
 * -----
 * Last Modified: 2022-10-03 01:00:41
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
    if (_state?.controllers != null) {
      Map<String, _MFormMaps> maps = _state!.controllers;
      data.forEach((key, value) {
        /// 忽略
        if (key == '__title') return;
        if (maps.containsKey(key)) {
          switch (maps[key]?.controller.runtimeType) {
            case ITextEditingController:
              (maps[key]?.controller as ITextEditingController).text = value;
              break;
            case GroupButtonController:
              List<MFormItemSelectItem> _data = maps[key]?.props?.items ?? [];
              MFormItemSelectItem v = _data.firstWhere((v) => v.value == value, orElse: () => MFormItemSelectItem(label: '', value: null));
              (maps[key]?.controller as GroupButtonController).selectIndex(_data.indexOf(v));
              break;
            default:
              maps[key] = _MFormMaps(controller: value, props: maps[key]?.props);
          }
        }
      });
      // ignore: invalid_use_of_protected_member
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

  void getData(
    Function(Map<String, dynamic>) onSuccess, {
    Function(String)? onError,
  }) {
    if (_state == null) {
      onError?.call('_MFormState not init');
      return;
    }
    Map<String, dynamic> v = {};
    bool status = true;
    for (var i in _state!.widget.children) {
      if (i.verification != null && i.field != '__title') {
        switch (i.type) {
          case MFormItemType.textField:
            String? error = i.verification!.call((_state!.controllers[i.field]!.controller as ITextEditingController).text);
            if (error != null) {
              onError?.call(error);
              status = false;
              return;
            }
            v[i.field] = (_state!.controllers[i.field]!.controller as ITextEditingController).text;
            break;
          case MFormItemType.radio:
            int? index = (_state!.controllers[i.field]!.controller as GroupButtonController).selectedIndex;
            dynamic value;
            if (index != null) {
              value = (_state!.controllers[i.field]!.props as MFormItemSelectProps).items[index].value;
            }
            String? error = i.verification!.call(value);
            if (error != null) {
              onError?.call(error);
              status = false;
              return;
            }
            v[i.field] = value;
            break;
          default:
            String? error = i.verification!.call(_state!.controllers[i.field]!.controller);
            if (error != null) {
              onError?.call(error);
              status = false;
              return;
            }
            v[i.field] = _state!.controllers[i.field]!.controller;
        }
      }
      if (!status) {
        break;
      }
    }
    onSuccess(v);
  }
}

class MForm extends StatefulWidget {
  final List<MFormItem> children;

  final MFormController? controller;

  final Function(String)? onChanged;

  final bool showError;

  final bool showDivider;

  final MukaFormTheme? config;

  final bool? readOnly;

  const MForm({
    Key? key,
    required this.children,
    this.controller,
    this.onChanged,
    this.showError = false,
    this.showDivider = false,
    this.config,
    this.readOnly,
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
            props: e.props,
            controller: ITextEditingController(text: e.initValue),
          );
          break;
        case MFormItemType.radio:
          MFormItemSelectProps? props = e.props as MFormItemSelectProps?;
          List<MFormItemSelectItem> data = props?.items ?? [];
          MFormItemSelectItem v = data.firstWhere((v) => v.value == e.initValue, orElse: () => MFormItemSelectItem(label: '', value: null));
          controllers[e.field] = _MFormMaps(
            props: e.props,
            controller: GroupButtonController(selectedIndex: data.indexOf(v)),
          );
          break;
        default:
          controllers[e.field] = _MFormMaps(
            controller: e.initValue,
            props: e.props,
          );
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
              props: e.props,
              controller: ITextEditingController(text: e.initValue),
            );
            break;
          case MFormItemType.radio:
            MFormItemSelectProps? props = e.props as MFormItemSelectProps?;
            List<MFormItemSelectItem> data = props?.items ?? [];
            MFormItemSelectItem v =
                data.firstWhere((v) => v.value == e.initValue, orElse: () => MFormItemSelectItem(label: '', value: null));
            controllers[e.field] = _MFormMaps(
              props: e.props,
              controller: GroupButtonController(selectedIndex: data.indexOf(v)),
            );
            break;
          default:
            controllers[e.field] = _MFormMaps(
              controller: e.initValue,
              props: e.props,
            );
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
              showArrow: (e.type == MFormItemType.select || e.type == MFormItemType.time) ? true : e.showArrow ?? false,
              showDivider: e.showDivider ?? widget.showDivider,
              value: getValueView(e, _formTheme),
              onTap: () {
                switch (e.type) {
                  case MFormItemType.diy:
                    e.props?.onTap?.call();
                    break;
                  case MFormItemType.select:
                    MFormItemSelectProps? props = e.props as MFormItemSelectProps?;
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: (props?.items ?? [])
                            .map(
                              (v) => ListItem(
                                value: Text(v.label),
                                valueAlignment: Alignment.center,
                                showDivider: (props?.items ?? []).last == v ? false : true,
                                dividerIndex: 16,
                                dividerEndIndex: 16,
                                onTap: () {
                                  controllers[e.field] = _MFormMaps(controller: v.value, props: e.props);
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    );
                    break;
                  case MFormItemType.time:
                    MFormItemTimeProps? props = e.props as MFormItemTimeProps?;
                    showDatePicker(
                      context: context,
                      initialDate: Utils.isEmpty(controllers[e.field]?.controller ?? '')
                          ? DateTime.now()
                          : DateTime.parse(controllers[e.field]?.controller),
                      firstDate: props?.firstDate ?? DateTime.parse('1980-08-01'),
                      lastDate: props?.lastDate ?? DateTime.now(),
                    ).then((v) {
                      if (v != null) {
                        controllers[e.field] = _MFormMaps(controller: DateFormat('yyyy-MM-dd').format(v), props: e.props);
                        setState(() {});
                      }
                    });
                    break;
                  default:
                    return;
                }
              },
            ),
          )
          .toList(),
    );
  }

  Widget? getValueView(MFormItem e, MukaFormTheme theme) {
    switch (e.type) {
      case MFormItemType.textField:
        MFormItemTextFieldProps? props = e.props as MFormItemTextFieldProps?;
        return ITextField(
          controller: controllers[e.field]!.controller,
          hintText: props?.placeholder,
          maxLines: props?.maxLines ?? 1,
          contentPadding: EdgeInsets.zero,
          readOnly: widget.readOnly ?? props?.readOnly ?? false,
          keyboardType: props?.keyboardType ?? ITextInputType.text,
          textAlign: TextAlign.right,
          onChanged: (v) {
            if (e.props is MFormItemTextFieldProps) {
              String? err = props?.onChangedVerify?.call(v);
              widget.onChanged?.call(v);
              if (err != null) {
                controllers[e.field]?.controller.showError(err);
              } else {
                controllers[e.field]?.controller.clearError();
              }
            }
          },
        );
      case MFormItemType.radio:
        MFormItemSelectProps? props = e.props as MFormItemSelectProps?;
        return GroupButton<MFormItemSelectItem>(
          controller: controllers[e.field]?.controller,
          isRadio: true,
          buttons: props?.items ?? [],
          buttonBuilder: (selected, value, context) => GestureDetector(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio(
                  value: selected,
                  groupValue: true,
                  onChanged: (v) {
                    if (widget.readOnly ?? props?.readOnly ?? false) {
                      return;
                    }
                    (controllers[e.field]?.controller as GroupButtonController).selectIndex((props?.items ?? []).indexOf(value));
                  },
                ),
                Text(value.label),
              ],
            ),
            onTap: () {
              if (widget.readOnly ?? e.props?.readOnly ?? false) {
                return;
              }
              (controllers[e.field]?.controller as GroupButtonController).selectIndex((props?.items ?? []).indexOf(value));
            },
          ),
        );
      case MFormItemType.select:
        if (Utils.isEmpty(controllers[e.field]?.controller ?? '')) {
          return Text(
            e.props?.placeholder ?? '',
            style: Theme.of(context).inputDecorationTheme.hintStyle,
          );
        } else {
          List<MFormItemSelectItem> data = (e.props as MFormItemSelectProps?)?.items ?? [];
          MFormItemSelectItem v = data.firstWhere(
            (v) => v.value == (controllers[e.field]?.controller ?? ''),
            orElse: () => MFormItemSelectItem(label: '', value: null),
          );
          return Text(
            v.label,
            style: Theme.of(context).textTheme.subtitle1,
          );
        }

      default:
        return Utils.isEmpty(controllers[e.field]?.controller ?? '')
            ? Text(
                e.props?.placeholder ?? '',
                style: Theme.of(context).inputDecorationTheme.hintStyle,
              )
            : Text(
                controllers[e.field]?.controller.toString() ?? '',
                style: Theme.of(context).textTheme.subtitle1,
              );
    }
  }
}

enum MFormItemType {
  textField,

  radio,

  select,

  time,

  diy,
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

  final String? Function(dynamic)? verification;

  final MFormItemProps? props;

  MFormItem({
    required this.field,
    this.config,
    this.height,
    this.initValue = '',
    this.showArrow,
    this.showDivider,
    this.title,
    this.type = MFormItemType.textField,
    this.verification,
    this.props,
  });

  static MFormItem head({String? title, bool? showDivider, double? height}) {
    return MFormItem(
      field: '__title',
      height: height,
      title: title,
      showDivider: showDivider,
      type: MFormItemType.diy,
    );
  }
}

class MFormItemTextFieldProps extends MFormItemProps {
  final bool showDeleteIcon;

  final String? labelText;

  final TextAlign textAlign;

  /// 显示最大长度
  final bool isCount;

  /// 输入验证
  final String? Function(String)? onChangedVerify;

  final int? maxLines;

  final bool? readOnly;

  final String? placeholder;

  final void Function()? onTap;

  final ITextInputType? keyboardType;

  MFormItemTextFieldProps({
    this.showDeleteIcon = true,
    this.labelText,
    this.textAlign = TextAlign.start,
    this.isCount = false,
    this.onChangedVerify,
    this.maxLines,
    this.readOnly,
    this.placeholder,
    this.onTap,
    this.keyboardType,
  });
}

class MFormItemProps {
  final bool? readOnly;

  final String? placeholder;

  final void Function()? onTap;

  MFormItemProps({
    this.readOnly,
    this.placeholder,
    this.onTap,
  });
}

class MFormItemSelectItem {
  final String label;

  final dynamic value;

  MFormItemSelectItem({
    required this.label,
    required this.value,
  });
}

class MFormItemSelectProps extends MFormItemProps {
  final bool? readOnly;

  final String? placeholder;

  final void Function()? onTap;

  final List<MFormItemSelectItem> items;

  MFormItemSelectProps({
    required this.items,
    this.readOnly,
    this.placeholder,
    this.onTap,
  }) : super();
}

class MFormItemTimeProps extends MFormItemProps {
  final bool? readOnly;

  final String? placeholder;

  final void Function()? onTap;

  final DateTime? firstDate;

  final DateTime? lastDate;

  MFormItemTimeProps({
    this.firstDate,
    this.lastDate,
    this.readOnly,
    this.placeholder,
    this.onTap,
  }) : super();
}
