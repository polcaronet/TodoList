import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/app/core/auth/auth_provider.dart';
import 'package:todolist/app/core/ui/loader.dart';
import 'package:todolist/app/core/ui/messages.dart';
import 'package:todolist/app/core/ui/todo_list_ui_config.dart';
import 'package:todolist/app/core/validator/validators.dart';
import 'package:validatorless/validatorless.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() =>
      _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _picker = ImagePicker();
  int? _selectedItemIndex;

  @override
  void dispose() {
    _nameEC.dispose();
    super.dispose();
  }

  Future<void> _cropImage(
    Uint8List imageBytes,
  ) async {
    if (!mounted) return;
    final croppedData = await Navigator.of(
      context,
    ).push<Uint8List?>(
      MaterialPageRoute(
        builder: (context) => _ImageCropper(
          imageBytes: imageBytes,
        ),
      ),
    );

    if (croppedData != null) {
      await _uploadImage(croppedData);
    }
  }

  Future<void> _uploadImage(
    Uint8List imageBytes,
  ) async {
    try {
      final Directory tempDir =
          await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final file = await File(
        '$tempPath/profile_pic.jpg',
      ).writeAsBytes(imageBytes);

      print(
        'Arquivo temporário criado: ${file.path}',
      );
      print(
        'Tamanho do arquivo: ${imageBytes.length} bytes',
      );

      if (!mounted) return;
      Loader.show(context);

      await context
          .read<AuthProvider>()
          .uploadProfilePicture(file.path);

      Loader.hide();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Foto alterada com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e, s) {
      print('Erro ao alterar foto: $e');
      print('Stack trace: $s');
      Loader.hide();
      if (mounted) {
        Messages.of(context).showError(
          'Erro ao alterar a foto: ${e.toString()}',
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? imageFile = await _picker
        .pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final imageBytes =
          await imageFile.readAsBytes();
      _cropImage(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: TodoListUiConfig
                .drawerHeaderDecoration,
            padding: EdgeInsets.zero,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Selector<AuthProvider,
                    (String, String, String)>(
                  selector: (
                    context,
                    authProvider,
                  ) {
                    return (
                      authProvider.user
                              ?.displayName ??
                          'Não informado',
                      authProvider.user?.email ??
                          'Não informado',
                      authProvider
                              .user?.photoURL ??
                          '',
                    );
                  },
                  builder: (context, user, _) {
                    return Row(
                      children: [
                        InkWell(
                          onTap:
                              _pickAndUploadImage,
                          child: CircleAvatar(
                            backgroundImage: user
                                    .$3.isEmpty
                                ? null
                                : NetworkImage(
                                    user.$3,
                                  ),
                            radius: 30,
                            child: user.$3.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                  )
                                : Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child:
                                            Icon(
                                          Icons
                                              .camera_alt,
                                          color: Colors
                                              .white
                                              .withOpacity(
                                            0.7,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Text(
                                user.$1,
                                style: TodoListUiConfig
                                    .drawerTitleStyle,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),
                              Text(
                                user.$2,
                                style: TodoListUiConfig
                                    .drawerSubtitleStyle,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _selectedItemIndex = 0;
              });
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  _nameEC.text = context
                          .read<AuthProvider>()
                          .user
                          ?.displayName ??
                      '';
                  return AlertDialog(
                    title: const Text(
                      'Alterar Nome',
                    ),
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _nameEC,
                        decoration:
                            const InputDecoration(
                          labelText: 'Novo nome',
                        ),
                        validator: Validatorless
                            .multiple([
                          Validatorless.required(
                            'Nome obrigatório',
                          ),
                          Validatorless.min(
                            3,
                            'Nome precisa ter ao menos 3 caracteres',
                          ),
                          Validators.fullName(),
                        ]),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(
                          context,
                        ).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey
                                  .currentState
                                  ?.validate() ??
                              false) {
                            final newName =
                                _nameEC.text
                                    .trim();
                            if (!mounted) return;
                            Loader.show(context);
                            try {
                              await context
                                  .read<
                                      AuthProvider>()
                                  .updateDisplayName(
                                    newName,
                                  );
                              Loader.hide();
                              if (mounted) {
                                Navigator.of(
                                  context,
                                ).pop();
                                ScaffoldMessenger
                                    .of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Nome alterado com sucesso!',
                                    ),
                                    backgroundColor:
                                        Colors
                                            .green,
                                  ),
                                );
                              }
                            } catch (e) {
                              Loader.hide();
                              if (mounted) {
                                Navigator.of(
                                  context,
                                ).pop();
                                Messages.of(
                                  context,
                                ).showError(
                                  'Erro ao alterar o nome!',
                                );
                              }
                            }
                          }
                        },
                        child: const Text(
                          'Salvar',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            selected: _selectedItemIndex == 0,
            selectedTileColor: TodoListUiConfig
                .drawerItemSelectedBackground,
            leading: const Icon(Icons.edit),
            title: Text(
              'Alterar Nome',
              style: _selectedItemIndex == 0
                  ? TodoListUiConfig
                      .drawerItemSelectedStyle
                  : TodoListUiConfig
                      .drawerItemStyle,
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _selectedItemIndex = 1;
              });
              context
                  .read<AuthProvider>()
                  .logout()
                  .catchError((e) {
                Messages.of(
                  context,
                ).showError('Erro ao sair');
                // Desseleciona em caso de erro para não manter o estado visual
                setState(() {
                  _selectedItemIndex = null;
                });
              });
            },
            selected: _selectedItemIndex == 1,
            selectedTileColor: TodoListUiConfig
                .drawerItemSelectedBackground,
            leading: Icon(
              Icons.exit_to_app,
              color: _selectedItemIndex == 1
                  ? TodoListUiConfig
                      .drawerItemSelectedStyle
                      .color
                  : null,
            ),
            title: Text(
              'Sair',
              style: _selectedItemIndex == 1
                  ? TodoListUiConfig
                      .drawerItemSelectedStyle
                  : TodoListUiConfig
                      .drawerItemStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageCropper extends StatefulWidget {
  final Uint8List imageBytes;

  const _ImageCropper({required this.imageBytes});

  @override
  State<_ImageCropper> createState() =>
      _ImageCropperState();
}

class _ImageCropperState
    extends State<_ImageCropper> {
  final _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recortar Imagem'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _cropController.crop();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Crop(
            controller: _cropController,
            image: widget.imageBytes,
            onCropped: (result) {
              // A partir da versão 2.0+, onCropped retorna CropResult
              switch (result) {
                case CropSuccess(
                    :final croppedImage,
                  ):
                  Navigator.of(
                    context,
                  ).pop(croppedImage);
                case CropFailure():
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Erro ao recortar imagem',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            aspectRatio: 1.0,
            baseColor: Colors.grey.shade300,
            maskColor: Colors.black.withOpacity(
              0.5,
            ),
            radius: 20,
            withCircleUi: true,
          ),
        ),
      ),
    );
  }
}
