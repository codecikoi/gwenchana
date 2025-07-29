import 'package:gwenchana/core/data/models/words_data_raw.dart';
import 'package:gwenchana/core/domain/models/words_data.dart';

extension WordsDataRawExtension on WordsDataRaw {
  WordsData toWordsData() {
    return WordsData(korean: korean, english: english);
  }
}
