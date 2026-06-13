import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final Color? iconColor;
  final Color? titleColor;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isSwitch) {
      return SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(color: titleColor ?? Colors.white),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              )
            : null,
        value: switchValue ?? false,
        onChanged: onSwitchChanged,
        activeColor: Colors.green,
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leadingIcon != null
          ? Icon(
              leadingIcon,
              color: iconColor ?? Colors.grey[400],
              size: 22,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(color: titleColor ?? Colors.white),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}