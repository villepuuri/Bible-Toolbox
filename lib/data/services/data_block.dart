
/// The different text types used to create the text blocks
enum DataType { headline, author, translator, body, quote, list, prayer }

/// Holds data for a text block
///
/// Based on this, a list of data can be contained and data is easily formatted
/// to text pages.

class DataBlock {
  final DataType type;
  final String? text;
  final List<String>? items;

  DataBlock({required this.type, this.text, this.items})
    : // Make sure that the data is as expected based on the type
      assert(
        type == DataType.list || text != null,
        "For datatype: $type you need to set a text!",
      ),
      assert(
        type != DataType.list || items != null,
        "For a list you need to set a text!",
      );

  factory DataBlock.fromJson(Map<String, dynamic> json) {
    return DataBlock(
      type: json["type"],
      text: json["text"],
      items: (json["items"] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
