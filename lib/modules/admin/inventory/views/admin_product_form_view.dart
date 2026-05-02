import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/data/models/glow_product.dart';
import '../../../../app/services/product_service.dart';

class AdminProductFormView extends StatefulWidget {
  const AdminProductFormView({super.key});

  @override
  State<AdminProductFormView> createState() => _AdminProductFormViewState();
}

class _AdminProductFormViewState extends State<AdminProductFormView> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();

  GlowProduct? _editProduct;
  File? _imageFile;
  bool _isLoading = false;
  bool get _isEdit => _editProduct != null;

  @override
  void initState() {
    super.initState();
    _editProduct = Get.arguments as GlowProduct?;
    if (_editProduct != null) {
      _nameCtrl.text = _editProduct!.name;
      _descCtrl.text = _editProduct!.description;
      _priceCtrl.text = _editProduct!.price.toStringAsFixed(0);
      _stockCtrl.text = '${_editProduct!.stock}';
      _categoryCtrl.text = _editProduct!.category;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (p != null) setState(() => _imageFile = File(p.path));
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _priceCtrl.text.isEmpty) {
      Get.snackbar('Missing', 'Name and Price are required');
      return;
    }
    setState(() => _isLoading = true);
    try {
      List<String> imageUrls = _editProduct?.imageUrls ?? [];

      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref('products/images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_imageFile!);
        final url = await ref.getDownloadURL();
        imageUrls = [url];
      }

      final product = GlowProduct(
        id: _editProduct?.id ?? '',
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
        imageUrls: imageUrls,
        category: _categoryCtrl.text.trim().isNotEmpty
            ? _categoryCtrl.text.trim()
            : 'skincare',
        stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
        isActive: true,
        app: 'glowvella',
      );

      if (_isEdit) {
        await ProductService.to.updateProduct(product);
        Get.back();
        Get.snackbar('Updated', '${product.name} updated successfully');
      } else {
        await ProductService.to.addProduct(product);
        Get.back();
        Get.snackbar('Added', '${product.name} added successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not save product. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Product' : 'Add Product',
            style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Image picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppColors.divider, width: 1.5),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_imageFile!, fit: BoxFit.cover,
                            width: double.infinity),
                      )
                    : _editProduct?.imageUrl.isNotEmpty == true
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              _editProduct!.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: AppColors.textMuted),
                              const SizedBox(height: 8),
                              Text('Tap to upload image',
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 20),
            _field(_nameCtrl, 'Product Name', Icons.label_outline),
            const SizedBox(height: 14),
            _field(_descCtrl, 'Description', Icons.description_outlined,
                maxLines: 3),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                    child: _field(_priceCtrl, 'Price (PKR)',
                        Icons.payments_outlined,
                        type: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(
                    child: _field(_stockCtrl, 'Stock Qty',
                        Icons.inventory_outlined,
                        type: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 14),
            _field(_categoryCtrl, 'Category (e.g. serum, moisturiser)',
                Icons.category_outlined),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(_isEdit ? 'Update Product' : 'Add Product',
                        style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
