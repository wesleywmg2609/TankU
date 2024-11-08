import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_app_bar.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_date_field.dart';
import 'package:tankyou/components/my_dropdown.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_image_picker.dart';
import 'package:tankyou/components/my_loading_indicator.dart';
import 'package:tankyou/components/my_overlay_icon.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/components/my_text_field.dart';
import 'package:tankyou/database/database.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/models/tank.dart';

class EditTankPage extends StatefulWidget {
  final User user;
  final DatabaseReference tankRef;

  const EditTankPage({super.key, required this.user, required this.tankRef});

  @override
  State<EditTankPage> createState() => EditTankPageState();
}

class EditTankPageState extends State<EditTankPage> {
  Tank? tank;
  File? _image;
  String? _selectedWaterType;
  DateTime? _initialDate;
  final _controllers = {
    'name': TextEditingController(),
    'width': TextEditingController(),
    'depth': TextEditingController(),
    'height': TextEditingController(),
    'setupAt': TextEditingController(),
  };
  final List<TextEditingController> _equipmentControllers = [];
  final ValueNotifier<int> _volumeNotifier = ValueNotifier<int>(0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    updateTank();
    _addVolumeListeners();
  }

  void updateTank() async {
    setState(() {
      _isLoading = true;
    });

    getTankById(widget.tankRef, widget.user.uid).then((fetchedTank) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          tank = fetchedTank;
          _initializeFields();
          _isLoading = false;
        });
      });
    });
  }

  void _initializeFields() {
    if (tank != null) {
      _controllers['name']?.text = tank?.name ?? '';
      _selectedWaterType = tank!.waterType!.isNotEmpty ? tank!.waterType : null;
      _controllers['width']?.text =
          tank!.width != 0 ? tank!.width!.toString() : '';
      _controllers['depth']?.text =
          tank!.depth != 0 ? tank!.depth!.toString() : '';
      _controllers['height']?.text =
          tank!.height != 0 ? tank!.height!.toString() : '';
      _volumeNotifier.value =
          (tank!.width ?? 0) * (tank!.depth ?? 0) * (tank!.height ?? 0);

      _initialDate = DateTime.tryParse(tank!.setupAt) ?? DateTime.now();

      for (var equipment in tank!.equipments ?? []) {
        _equipmentControllers.add(TextEditingController(text: equipment));
      }
    }
  }

  void _addVolumeListeners() {
    _controllers['width']?.addListener(_calculateVolume);
    _controllers['depth']?.addListener(_calculateVolume);
    _controllers['height']?.addListener(_calculateVolume);
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _equipmentControllers.forEach((controller) => controller.dispose());
    _volumeNotifier.dispose();
    super.dispose();
  }

  Future<void> _updateTank() async {
    if (_isLoading) {
      displayMessageToUser('Tank data is not loaded yet', context);
      return;
    }

    showLoadingDialog(context);
    String? imageUrl;

    String name =
        await generateTankName(widget.user.uid, _controllers['name']!.text);
    tank!.name = name;

    if (_image != null) {
      if (tank!.imageUrl != null && tank!.imageUrl!.isNotEmpty) {
        await removeImageFromDatabase(tank!.id);
      }
      imageUrl = await uploadImage(widget.user.uid, _image!, 'tank_images');
    } else {
      imageUrl = tank!.imageUrl;
    }
    String? waterType = _selectedWaterType;
    int? width = int.tryParse(_controllers['width']!.text);
    int? depth = int.tryParse(_controllers['depth']!.text);
    int? height = int.tryParse(_controllers['height']!.text);
    String setupAt = convertToIso8601String(_controllers['setupAt']!.text);

    List<String> equipments = _equipmentControllers.map((c) => c.text).toList();

    Tank updatedTank = Tank(
      widget.user.uid,
      imageUrl,
      name,
      waterType,
      width,
      depth,
      height,
      setupAt,
      equipments,
    );

    updateTankToDatabase(updatedTank, tank!.id);

    Navigator.pop(context);

    displayMessageToUser('Tank updated successfully!', context);
  }

  void _onImagePicked(File? image) {
    setState(() {
      _image = image;
    });
  }

  void _onImageRemoved() async {
    setState(() {
      _image = null;
      tank!.imageUrl = null;
    });
  }

  void _calculateVolume() {
    final width = int.tryParse(_controllers['width']!.text) ?? 0;
    final depth = int.tryParse(_controllers['depth']!.text) ?? 0;
    final height = int.tryParse(_controllers['height']!.text) ?? 0;
    _volumeNotifier.value = width * depth * height;
  }

  void _addEquipmentField() {
    setState(() {
      _equipmentControllers.add(TextEditingController());
    });
  }

  void _removeEquipmentField(int index) {
    setState(() {
      _equipmentControllers[index].dispose();
      _equipmentControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MyLoadingIndicator();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              MyAppBar(
                title: 'Edit Tank',
                subtitle: tank?.name.toString(),
                trailing: const MyIcon(icon: Icons.check),
                onTrailingPressed: _updateTank,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImagePicker(
                          initialImageUrl: tank?.imageUrl,
                          initialFile: _image,
                          onImagePicked: _onImagePicked,
                          onImageRemoved: _onImageRemoved,
                        ),
                        MyTextField(
                          controller: _controllers['name']!,
                          icon: const MyOverlayIcon(
                              icon: Icons.call_to_action,
                              svgFilepath: 'assets/fish.svg',
                              padding: 3),
                          labelText: 'Tank Name',
                        ),
                        const SizedBox(height: 15),
                        MyDropdown(
                          icon: const MyIcon(icon: Icons.water),
                          labelText: 'Water Type',
                          selectedValue: _selectedWaterType,
                          items: const [
                            'Freshwater',
                            'Saltwater',
                            'Brackish',
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedWaterType = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        ValueListenableBuilder<int>(
                          valueListenable: _volumeNotifier,
                          builder: (context, volume, child) {
                            final widthText = _controllers['width']!.text;
                            final depthText = _controllers['depth']!.text;
                            final heightText = _controllers['height']!.text;

                            String widthDisplay =
                                widthText.isEmpty ? 'W' : widthText;
                            String depthDisplay =
                                depthText.isEmpty ? 'D' : depthText;
                            String heightDisplay =
                                heightText.isEmpty ? 'H' : heightText;

                            return Text(
                              'Volume: $widthDisplay x $depthDisplay x $heightDisplay = ${volume}cm³',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                letterSpacing: 1.0,
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                                child: MyTextField(
                                    controller: _controllers['width']!,
                                    icon:
                                        const MyIcon(icon: Icons.aspect_ratio),
                                    labelText: 'Width',
                                    isNumeric: true)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: MyTextField(
                                    controller: _controllers['depth']!,
                                    icon:
                                        const MyIcon(icon: Icons.aspect_ratio),
                                    labelText: 'Depth',
                                    isNumeric: true)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: MyTextField(
                                    controller: _controllers['height']!,
                                    icon:
                                        const MyIcon(icon: Icons.aspect_ratio),
                                    labelText: 'Height',
                                    isNumeric: true)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        MyDateField(
                          controller: _controllers['setupAt']!,
                          icon: const MyIcon(icon: Icons.calendar_today),
                          initialDate: _initialDate!,
                        ),
                        const SizedBox(height: 15),
                        const MyText(
                          text: 'Equipment:',
                          isBold: true,
                          letterSpacing: 1.0,
                          size: 14,
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: List.generate(_equipmentControllers.length,
                              (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      controller: _equipmentControllers[index],
                                      icon: const MyIcon(icon: Icons.build),
                                      labelText: 'Equipment Name',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _removeEquipmentField(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyButton(
                                onPressed: _addEquipmentField,
                                child: const MyIcon(icon: Icons.add))
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
