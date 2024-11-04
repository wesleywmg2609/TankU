import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_date_field.dart';
import 'package:tankyou/components/my_dropdown.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_overlay_icon.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/database/database.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/helper/widgets.dart';
import 'package:tankyou/models/tank.dart';

class AddTankPage extends StatefulWidget {
  final User user;

  const AddTankPage({
    super.key,
    required this.user,
  });

  @override
  State<AddTankPage> createState() => _AddTankPageState();
}

class _AddTankPageState extends State<AddTankPage> {
  File? _image;
  final _nameController = TextEditingController();
  String? _selectedWaterType;
  final ValueNotifier<int> _volumeNotifier = ValueNotifier<int>(0);
  final _widthController = TextEditingController();
  final _depthController = TextEditingController();
  final _heightController = TextEditingController();
  final _setupAtController = TextEditingController();
  final List<TextEditingController> _equipmentControllers = [];

  @override
  void initState() {
    super.initState();
    _widthController.addListener(_calculateVolume);
    _depthController.addListener(_calculateVolume);
    _heightController.addListener(_calculateVolume);
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

    void _resetFields() {
      _nameController.clear();
      _widthController.clear();
      _depthController.clear();
      _heightController.clear();
      _selectedWaterType = null;
      _image = null;
      _volumeNotifier.value = 0;

      for (var controller in _equipmentControllers) {
        controller.dispose();
      }
      _equipmentControllers.clear();
    }

  Future<void> _addTank() async {

  showLoadingDialog(context);

  String name = await generateTankName(widget.user.uid, _nameController.text);
  String? imageUrl;
  String? waterType = _selectedWaterType;
  double? width = double.tryParse(_widthController.text);
  double? depth = double.tryParse(_depthController.text);
  double? height = double.tryParse(_heightController.text);
  String setupAt = convertToIso8601String(_setupAtController.text);

  List<String> equipments = _equipmentControllers.map((c) => c.text).toList();

  if (_image != null) {
    imageUrl = await uploadImage(widget.user.uid, _image!, 'tank_images');
  }

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

  tank.setId(addTankToDatabase(tank));

  _resetFields();

  Navigator.pop(context);

  displayMessageToUser('Tank added successfully!', context);
}

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
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
              buildAppBar(
                'Add Tank',
                trailing: const MyIcon(icon: Icons.check),
                onTrailingPressed: _addTank,
                
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
                                  child: _image == null
                                      ? const SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: Icon(
                                            Icons.camera_alt,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                            _image!,
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_image != null)
                          GestureDetector(
                            onTap: _removeImage,
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
                        buildTextField(
                            _nameController,
                            const MyOverlayIcon(icon: Icons.call_to_action, svgFilepath: 'assets/fish.svg', padding: 3),
                            'Tank Name',
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
                                child: buildTextField(
                                    _widthController,
                                    const MyIcon(icon: Icons.aspect_ratio),
                                    'Width',
                                    isNumeric: true
                                  )
                                ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: buildTextField(
                                    _depthController,
                                    const MyIcon(icon: Icons.aspect_ratio),
                                    'Depth',
                                    isNumeric: true
                                  )
                                ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: buildTextField(
                                    _heightController,
                                    const MyIcon(icon: Icons.aspect_ratio),
                                    'Height',
                                    isNumeric: true
                                  )
                                ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        MyDateField(
                            controller: _setupAtController,
                            icon: const MyIcon(icon: Icons.calendar_today)
                            ),
                        const SizedBox(height: 15),
                        const MyText( text: 'Equipment:',
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
                                    child: buildTextField(
                                        _equipmentControllers[index],
                                        const MyIcon(icon: Icons.build),
                                        'Equipment Name',
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
                              child: const MyIcon(icon: Icons.add)
                            )
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
