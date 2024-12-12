class MyProduct {
  String? productId;
  String? productName;
  String? productPicture;
  String? productDescription;
  String? productQuantity;
  String? productPrice;

  MyProduct(
      {this.productId,
      this.productName,
      this.productPicture,
      this.productDescription,
      this.productQuantity,
      this.productPrice});
  MyProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productPicture = json['product_picture'];
    productDescription = json['product_description'];
    productQuantity = json['product_quantity'];
    productPrice = json['product_price'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_picture'] = productPicture;
    data['product_description'] = productDescription;
    data['product_quantity'] = productQuantity;
    data['product_price'] = productPrice;
    return data;
  }
}
