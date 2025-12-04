library shadcn_select;

export 'select_view.dart';
export 'select_view_model.dart';
export 'select_delegate.dart';

import 'select_view.dart';
import 'select_view_model.dart';

typedef ShadcnSelect<T> = ShadcnSelectView<T>;
typedef SelectOption<T> = ShadcnSelectOption<T>;
