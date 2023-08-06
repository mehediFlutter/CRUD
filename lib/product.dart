class Product {
  final String id,
      ProductName,
      ProductCode,
      Img,
      UnitPrice,
      Qty,
      TotalPrice,
      CreatedDate;

  Product(this.id, this.ProductName, this.ProductCode, this.Img, this.UnitPrice,
      this.Qty, this.TotalPrice, this.CreatedDate);

  factory Product.toJson(Map<String, dynamic> e) {
    return Product(e["_id"], e["ProductName"], e["ProductCode"], e["Img"],
        e["UnitPrice"], e["Qty"], e["TotalPrice"], e["CreatedDate"]);
  }
}
