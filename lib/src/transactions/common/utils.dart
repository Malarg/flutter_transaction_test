import 'package:easy_localization/easy_localization.dart';

import 'data/models/transaction_type.dart';

class TransactionUtils {
  static String getLocalizedTypeString(TransactionType type) {
    return switch (type) {
      TransactionType.deposit => 'transaction.type.deposit'.tr(),
      TransactionType.transfer => 'transaction.type.transfer'.tr(),
      TransactionType.withdrawal => 'transaction.type.withdrawal'.tr(),
    };
  }
}
