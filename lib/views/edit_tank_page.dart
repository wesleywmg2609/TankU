import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanku/widgets/my_app_bar.dart';
import 'package:tanku/widgets/my_button.dart';
import 'package:tanku/widgets/my_date_field.dart';
import 'package:tanku/widgets/my_dropdown.dart';
import 'package:tanku/widgets/my_icon.dart';
import 'package:tanku/widgets/my_image_picker.dart';
import 'package:tanku/widgets/my_loading_indicator.dart';
import 'package:tanku/widgets/my_text.dart';
import 'package:tanku/widgets/my_text_field.dart';
import 'package:tanku/services/tank_service.dart';
import 'package:tanku/services/image_service.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/tank.dart';

class EditTankPage extends StatefulWidget {
  final User user;
  final DatabaseReference tankRef;

  const EditTankPage({super.key, required this.user, required this.tankRef});

  @override
  State<EditTankPage> createState() => EditTankPageState();
}

class EditTankPageState extends State<EditTankPage> {
  late TankService _tankService;
  late ImageService _imageService;
  Tank? _tank;
  String? _imageUrl;
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
    _tankService = Provider.of<TankService>(context, listen: false);
    _imageService = Provider.of<ImageService>(context, listen: false);
    _tankService.listenToTankUpdates(widget.tankRef);
    _addVolumeListeners();

    _tankService.addListener(() {
      if (mounted) {
        setState(() {
          _tank = _tankService.tank;
          _initializeFields();
          _isLoading = _tankService.isLoading;
        });
      }
    });

    _imageService.addListener(() {
      if (mounted) {
        setState(() {
          _imageUrl = _imageService.imageUrl;
        });
      }
      if (_imageUrl != null) {
        _tankService.updateImageUrlInTankRef(widget.tankRef,
            imageUrl: _imageUrl!);
      }
    });
  }

  @override
  void dispose() {
    _tankService.removeListener(() {});
    _imageService.removeListener(() {});
    _controllers.values.forEach((controller) => controller.dispose());
    _equipmentControllers.forEach((controller) => controller.dispose());
    _volumeNotifier.dispose();
    super.dispose();
  }

  void _initializeFields() {
    if (_tank != null) {
      _controllers['name']?.text = _tank?.name ?? '';
      _selectedWaterType =
          _tank!.waterType!.isNotEmpty ? _tank!.waterType : null;
      _controllers['width']?.text =
          _tank!.width != 0 ? _tank!.width!.toString() : '';
      _controllers['depth']?.text =
          _tank!.depth != 0 ? _tank!.depth!.toString() : '';
      _controllers['height']?.text =
          _tank!.height != 0 ? _tank!.height!.toString() : '';
      _volumeNotifier.value =
          (_tank!.width ?? 0) * (_tank!.depth ?? 0) * (_tank!.height ?? 0);

      _initialDate = DateTime.tryParse(_tank!.setupAt) ?? DateTime.now();

      _equipmentControllers.clear();
      for (var equipment in _tank!.equipments ?? []) {
        _equipmentControllers.add(TextEditingController(text: equipment));
      }
    }
  }

  void _addVolumeListeners() {
    _controllers['width']?.addListener(_calculateVolume);
    _controllers['depth']?.addListener(_calculateVolume);
    _controllers['height']?.addListener(_calculateVolume);
  }

  Future<void> _updateTank() async {
    if (_isLoading) {
      displayMessageToUser('Tank data is not loaded yet', context);
      return;
    }

    showLoadingDialog(context);

    String name =
        await _tankService.generateTankName(_controllers['name']!.text);
    _tank!.name = name;

    String? imageUrl = _imageUrl;
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

    _tankService.updateTankToDatabase(updatedTank, _tank!.id);

    Navigator.pop(context);

    displayMessageToUser('Tank updated successfully!', context);
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

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String labelText,
    bool isNumeric = false,
  }) {
    return MyTextField(
      controller: controller,
      icon: icon,
      labelText: labelText,
      isNumeric: isNumeric,
    );
  }

  Widget _buildVolumeDisplay() {
    return ValueListenableBuilder<int>(
      valueListenable: _volumeNotifier,
      builder: (context, volume, child) {
        final widthText = _controllers['width']!.text;
        final depthText = _controllers['depth']!.text;
        final heightText = _controllers['height']!.text;

        String widthDisplay = widthText.isEmpty ? 'W' : widthText;
        String depthDisplay = depthText.isEmpty ? 'D' : depthText;
        String heightDisplay = heightText.isEmpty ? 'H' : heightText;

        return MyText(
          text:
              'Volume: $widthDisplay x $depthDisplay x $heightDisplay = ${volume}cm³',
          letterSpacing: 2.0,
          isBold: true,
          size: 14,
        );
      },
    );
  }

  Widget _buildEquipmentField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _equipmentControllers[index],
              icon: Icons.build,
              labelText: 'Equipment Name',
            ),
          ),
          GestureDetector(
            onTap: () => _removeEquipmentField(index),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: MyIcon(
                icon: Icons.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
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
                subtitle: _tank?.name.toString(),
                onLeadingPressed: () {
                  _imageService.imageUrl = null;
                  Navigator.pop(context);
                },
                trailing: const MyIcon(icon: Icons.check),
                onTrailingPressed: _updateTank,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImagePicker(
                            imageUrl: _tank!.imageUrl!, tankRef: _tank!.id),
                        _buildTextField(
                          controller: _controllers['name']!,
                          icon: Icons.call_to_action,
                          labelText: 'Tank Name',
                        ),
                        const SizedBox(height: 15),
                        MyDropdown(
                          icon: Icons.water,
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
                        _buildVolumeDisplay(),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                              controller: _controllers['width']!,
                              icon: Icons.aspect_ratio,
                              labelText: 'Width',
                              isNumeric: true,
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTextField(
                                controller: _controllers['depth']!,
                                icon: Icons.aspect_ratio,
                                labelText: 'Depth',
                                isNumeric: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTextField(
                                controller: _controllers['height']!,
                                icon: Icons.aspect_ratio,
                                labelText: 'Height',
                                isNumeric: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        MyDateField(
                          controller: _controllers['setupAt']!,
                          icon: Icons.calendar_today,
                          initialDate: _initialDate!,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        ),
                        const SizedBox(height: 15),
                        const MyText(
                          text: 'Equipment:',
                          isBold: true,
                          letterSpacing: 1.0,
                          size: 14,
                        ),
                        const SizedBox(height: 15),
                        ...List.generate(_equipmentControllers.length,
                            (index) => _buildEquipmentField(index)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyButton(
                                onPressed: _addEquipmentField,
                                child: const MyIcon(icon: Icons.add))
                          ],
                        ),
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
