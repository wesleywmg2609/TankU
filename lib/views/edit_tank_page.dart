import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tankyou/components/my_app_bar.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_date_field.dart';
import 'package:tankyou/components/my_dropdown.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_image.dart';
import 'package:tankyou/components/my_overlay_icon.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/components/my_text_field.dart';
import 'package:tankyou/database/database.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/models/tank.dart';

class EditTankPage extends StatefulWidget {
  final User user;
  final Tank tank;

  const EditTankPage({super.key, required this.user, required this.tank});

  @override
  State<EditTankPage> createState() => _EditTankPageState();
}

class _EditTankPageState extends State<EditTankPage> {
  File? _image;
  String? _selectedWaterType;
  final _nameController = TextEditingController();
  final _widthController = TextEditingController();
  final _depthController = TextEditingController();
  final _heightController = TextEditingController();
  final _setupAtController = TextEditingController();
  final List<TextEditingController> _equipmentControllers = [];
  final ValueNotifier<int> _volumeNotifier = ValueNotifier<int>(0);

  get http => null;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _widthController.addListener(_calculateVolume);
    _depthController.addListener(_calculateVolume);
    _heightController.addListener(_calculateVolume);
  }

  void _initializeFields() {
    _nameController.text = widget.tank.name!;
    if (widget.tank.waterType != null && widget.tank.waterType!.isNotEmpty) {
      _selectedWaterType = widget.tank.waterType;
    }
    _widthController.text =
        widget.tank.width != 0 ? widget.tank.width!.toString() : '';
    _depthController.text =
        widget.tank.depth != 0 ? widget.tank.depth!.toString() : '';
    _heightController.text =
        widget.tank.height != 0 ? widget.tank.height!.toString() : '';

    _volumeNotifier.value = (widget.tank.width ?? 0) *
        (widget.tank.depth ?? 0) *
        (widget.tank.height ?? 0);

    for (var equipment in widget.tank.equipments!) {
      _equipmentControllers.add(TextEditingController(text: equipment));
    }

    _image = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _depthController.dispose();
    _heightController.dispose();
    _setupAtController.dispose();
    _volumeNotifier.dispose();

    for (var controller in _equipmentControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _updateTank() async {
    showLoadingDialog(context);
    String? imageUrl;

    String name = await generateTankName(widget.user.uid, _nameController.text);
    widget.tank.name = name;

    if (_image != null) {
      imageUrl = await uploadImage(widget.user.uid, _image!, 'tank_images');
    } else {
      imageUrl = widget.tank.imageUrl;
    }
    String? waterType = _selectedWaterType;
    int? width = int.tryParse(_widthController.text);
    int? depth = int.tryParse(_depthController.text);
    int? height = int.tryParse(_heightController.text);
    String setupAt = convertToIso8601String(_setupAtController.text);

    List<String> equipments = _equipmentControllers.map((c) => c.text).toList();

    Tank tank = Tank(
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

    tank.setId(widget.tank.id);

    updateTankToDatabase(tank, tank.id);

    Navigator.pop(context);

    displayMessageToUser('Tank edited successfully!', context);
  }

  Future<void> _pickImage() async {

    if (widget.tank.imageUrl != null && widget.tank.imageUrl!.isNotEmpty) {
      _removeImage(widget.tank.id);
      displayMessageToUser("Photo removed successfully!", context);
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage(DatabaseReference id) async {
  try {
    await removeImageFromDatabase(id);
    
    setState(() {
      widget.tank.imageUrl = null;
      _image = null;
    });

    logger("Successfully removed image for tank with ID: ${id.key}");
  } catch (e) {
    logger("Error removing image for tank with ID: ${id.key}. Error: $e");
  }
  }

  void _calculateVolume() {
    final width = int.tryParse(_widthController.text) ?? 0;
    final depth = int.tryParse(_depthController.text) ?? 0;
    final height = int.tryParse(_heightController.text) ?? 0;

    final volume = width * depth * height;
    _volumeNotifier.value = volume;
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
    MyBoxShadows shadows = MyBoxShadows();

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
              subtitle: widget.tank.name.toString(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    shadows.darkShadow(context),
                                    shadows.lightShadow(context),
                                  ],
                                ),
                                child: Center(
                                  child: widget.tank.imageUrl != null && widget.tank.imageUrl!.isNotEmpty
                                      ? MyImageLoader(url: widget.tank.imageUrl, size: 150)
                                      : _image == null
                                          ? const SizedBox(
                                              width: 150,
                                              height: 150,
                                              child: Icon(
                                                Icons.camera_alt,
                                              ),
                                            )
                                          : MyImageLoader(file: _image, size: 150),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_image != null || (widget.tank.imageUrl != null && widget.tank.imageUrl!.isNotEmpty))
                          GestureDetector(
                            onTap: () => _removeImage(widget.tank.id),
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 15),
                        MyTextField(
                          controller: _nameController,
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
                            final widthText = _widthController.text;
                            final depthText = _depthController.text;
                            final heightText = _heightController.text;

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
                                    controller: _widthController,
                                    icon:
                                        const MyIcon(icon: Icons.aspect_ratio),
                                    labelText: 'Width',
                                    isNumeric: true)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: MyTextField(
                                    controller: _depthController,
                                    icon:
                                        const MyIcon(icon: Icons.aspect_ratio),
                                    labelText: 'Depth',
                                    isNumeric: true)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: MyTextField(
                                    controller: _heightController,
                                    icon:
                                        const MyIcon(icon: Icons.aspect_ratio),
                                    labelText: 'Height',
                                    isNumeric: true)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        MyDateField(
                          controller: _setupAtController,
                          icon: const MyIcon(icon: Icons.calendar_today),
                          initialDate: DateTime.parse(widget.tank.setupAt!),
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
