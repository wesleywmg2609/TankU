import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanku/components/my_app_bar.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_date_field.dart';
import 'package:tanku/components/my_dropdown.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_image_picker.dart';
import 'package:tanku/components/my_overlay_icon.dart';
import 'package:tanku/components/my_text.dart';
import 'package:tanku/components/my_text_field.dart';
import 'package:tanku/services/tank_service.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/services/image_service.dart';

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
  late TankService _tankService;
  late ImageService _imageService;
  String? _imageUrl;
  String? _selectedWaterType;
  final _controllers = {
    'name': TextEditingController(),
    'width': TextEditingController(),
    'depth': TextEditingController(),
    'height': TextEditingController(),
    'setupAt': TextEditingController(),
  };
  final List<TextEditingController> _equipmentControllers = [];
  final ValueNotifier<int> _volumeNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _imageService = Provider.of<ImageService>(context, listen: false);
    _addVolumeListeners();

    _imageService.addListener(() {
      if (mounted) {
        setState(() {
          _imageUrl = _imageService.imageUrl;
        });
      }
    });
  }

  @override
  void dispose() {
    _imageService.removeListener(() {});
    _controllers.values.forEach((controller) => controller.dispose());
    _equipmentControllers.forEach((controller) => controller.dispose());
    _volumeNotifier.dispose();
    super.dispose();
  }

  void _addVolumeListeners() {
    _controllers['width']?.addListener(_calculateVolume);
    _controllers['depth']?.addListener(_calculateVolume);
    _controllers['height']?.addListener(_calculateVolume);
  }

  Future<void> _addTank() async {
    showLoadingDialog(context);

    String name =
        await _tankService.generateTankName(_controllers['name']!.text);
    String? imageUrl = _imageUrl;
    String? waterType = _selectedWaterType;
    int? width = int.tryParse(_controllers['width']!.text);
    int? depth = int.tryParse(_controllers['depth']!.text);
    int? height = int.tryParse(_controllers['height']!.text);
    String setupAt = convertToIso8601String(_controllers['setupAt']!.text);

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

    tank.setId(_tankService.addTankToDatabase(tank));

    _resetFields();

    Navigator.pop(context);

    displayMessageToUser('Tank added successfully!', context);
  }

  void _resetFields() {
    _controllers['name']!.clear();
    _controllers['width']!.clear();
    _controllers['depth']!.clear();
    _controllers['height']!.clear();
    setState(() {
      _selectedWaterType = null;
      _imageService.imageUrl = null;
    });

    for (var controller in _equipmentControllers) {
      controller.dispose();
    }
    _equipmentControllers.clear();
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
                title: 'Add Tank',
                leading: const MyIcon(icon: Icons.arrow_back),
                onLeadingPressed: () {
                  if (_imageUrl != null && _imageUrl!.isNotEmpty) {
                    _imageService.deleteImage(_imageUrl!);
                  }
                  Navigator.pop(context);
                },
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
                        MyImagePicker(),
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
                          initialDate: DateTime.now(),
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
