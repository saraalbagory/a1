import 'package:a1/stores/data/models/store_model.dart';

class StoreResponseModel {
    List<StoreModel> results;
   // Context context;

    StoreResponseModel({
        required this.results,
      //  required this.context,
    });
    factory StoreResponseModel.fromJson(Map<String, dynamic> json) {
        return StoreResponseModel(
            results: List<StoreModel>.from(json['results'].map((x) => StoreModel.fromJson(x))),
          //  context: Context.fromJson(json['context']),
        );
    }

}

// class Context {
//     GeoBounds geoBounds;

//     Context({
//         required this.geoBounds,
//     });

// }



// class Icon {
//     String prefix;
//     Suffix suffix;

//     Icon({
//         required this.prefix,
//         required this.suffix,
//     });

// }

// enum Suffix {
//     PNG
// }



