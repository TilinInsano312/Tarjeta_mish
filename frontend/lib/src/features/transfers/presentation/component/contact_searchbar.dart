import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContactSearchBar extends HookWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const ContactSearchBar({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF5F5F5),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged?.call(),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre',
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF999999),
            size: 24,
          ),
          filled: true,
          fillColor: Colors.white,          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(0xFFBBBBBB),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}