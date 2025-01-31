{% if flag?(:windows) && flag?(:x86_64) %}
  @[Link(ldflags: "#{__DIR__}/../lib/windows/libtinyfiledialogs.a")]
{% elsif flag?(:linux) && flag?(:x86_64) %}
  @[Link(ldflags: "#{__DIR__}/../lib/linux/libtinyfiledialogs.a")]
{% end %}

lib Tinyfiledialogs
  # Beeps
  fun beep = tinyfd_beep

  # Icon can be "info", "warning", or "error"
  fun notify_popup = tinyfd_notifyPopup(title : LibC::Char*, message : LibC::Char*, icon : LibC::Char*)

  # Type can be "ok", "okcancel", "yesno", or "yesnocancel"
  # Icon can be "info", "warning", "error", or "question"
  # Returns 0 for cancel/no, 1 for ok/yes, or 2 for no in yesnocancel
  fun message_box = tinyfd_messageBox(title : LibC::Char*, message : LibC::Char*, type : LibC::Char*, icon : LibC::Char*, default : LibC::Int) : LibC::Int

  # Default can be NULL for a password box, or "" for an input box
  # Returns the input, or NULL on cancel
  fun input_box = tinyfd_inputBox(title : LibC::Char*, message : LibC::Char*, default : LibC::Char*) : LibC::Char*

  # Title can be NULL
  # Default can be NULL, "", and set ending with "/" to denote a directory
  # Filter count needs to be the same size as filter_patterns
  # Filter patterns can be NULL, or an Array of a defined size in filter_count
  # Description can be NULL
  # Returns NULL on cancel, or the path selected otherwise
  fun save_file_dialog = tinyfd_saveFileDialog(title : LibC::Char*, default : LibC::Char*, filter_count : LibC::Int, filter_patterns : LibC::Char**, description : LibC::Char*) : LibC::Char*

  # Title can be NULL
  # Default can be NULL, "", and set ending with "/" to denote a directory
  # Filter count needs to be the same size as filter_patterns
  # Filter patterns can be NULL, or an Array of a defined size in filter_count
  # Description can be NULL
  # Multiple selects can be 0 for single file or 1 for multiple
  # Returns NULL on cancel, a path to a file, or a path of multiple files separated by "|"
  fun open_file_dialog = tinyfd_openFileDialog(title : LibC::Char*, default : LibC::Char*, filter_count : LibC::Int, filter_patterns : LibC::Char**, description : LibC::Char*, multiple_selects : LibC::Int) : LibC::Char*

  # Title and default can be NULL
  # Returns NULL on cancel
  fun select_folder_dialog = tinyfd_selectFolderDialog(title : LibC::Char*, default : LibC::Char*) : LibC::Char*

  # Title can be NULL
  # Default HEXRGB can be NULL
  # Returns hexcolor as string, or NULL on cancel
  # Result RGB Array also contains result
  # DefaultRGB only used id default hex rgb is NULL
  fun color_chooser = tinyfd_colorChooser(title : LibC::Char*, default_hex_rgb : LibC::Char*, default_rgb : StaticArray(LibC::UChar, 3), result_rgb : StaticArray(LibC::UChar, 3)*) : LibC::Char*
end

module FileDialogs

  # Beep
  def self.beep
    Tinyfiledialogs.beep
  end

  # Creates a notification popup
  # Requires (title: String, message: String)
  # Optional (icon: String) defaults to "info". Can also be "warning", or "error"
  def self.notify_popup(*, title : String, message : String, icon : String = "info")
    Tinyfiledialogs.notify_popup(title, message, icon)
  end

  # Creates a message popup
  # Requires (title: String, message: String)
  # Optional (type: String) defaults to "ok". Can also be "okaycancel", "yesno", or "yesnocancel", determining which buttons are shown.
  # Optional (icon: String) defaults to "info". Can also be "warning", "error", or "question".
  # Options (default: Int) defaults to 0. Determines which button is highlighted by default.
  # Returns Symbol of :cancel, :no, :ok, or :yes depending on pressed button. Returns :cancel if no button was pressed.
  def self.message_box(*, title : String, message : String, type : String = "ok", icon : String = "info", default : Int = 0) : Symbol
    case Tinyfiledialogs.message_box(title, message, type, icon, default)
    when 0
      type == "okaycancel" ? :cancel : :no
    when 1
      type == "okaycancel" ? :ok : :yes
    when 2
      :no
    end
    :cancel
  end

  # Creates a text input box.
  # Requires (title: String, message: String)
  # Optional (default: String | Nil) defaults to nil. Determines the default string in the input box. Use nil for a password box.
  # Returns a String (the input text) or nil (on canceling input).
  def self.input_box(*, title : String, message : String, default : String | Nil = nil) : String | Nil
    if (result = Tinyfiledialogs.input_box(title, message, default)).null?
      nil
    else
      String.new(result)
    end
  end

  # Creates a saving file location dialog.
  # Optional (title: String | Nil) defaults to nil.
  # Optional (default: String | Nil) defaults to nil. Determines default saving location and/or directory. End with "/" to indicate choosing a directory rather than a filename.
  # Optional (filter_patterns: Array(String) | Nil) defaults to nil. Use an array of filetypes formatted like ["*.txt", "*.png"] to determine filters.
  # Optional (description: String | Nil) defaults to nil. Use to show a description of the file you're saving or other info.
  # Returns a string denoting choice of where to save a file, or nil upon canceling. Does not do any File IO.
  def self.save_file_dialog(*, title : String | Nil = nil, default : String | Nil = nil, filter_patterns : Array(String) | Nil = nil, description : String | Nil = nil) : String | Nil
    pattern_size = filter_patterns.nil? ? 0 : filter_patterns.size
    filters = filter_patterns.nil? ? nil : filter_patterns.map(&.to_unsafe)
    if (result = Tinyfiledialogs.save_file_dialog(title, default, pattern_size, filters, description)).null?
      nil
    else
      String.new(result)
    end
  end

  # Creates a open file(s) location dialog.
  # Optional (title: String | Nil) defaults to nil.
  # Optional (default: String | Nil) defaults to nil. Determines default opening location and/or directory. End with "/" to indicate choosing a directory rather than a filename.
  # Optional (filter_patterns: Array(String) | Nil) defaults to nil. Use an array of filetypes formatted like ["*.txt", "*.png"] to determine filters.
  # Optional (description: String | Nil) defaults to nil. Use to show a description of the file you're opening or other info.
  # Optional (multiple_selects: Bool) defaults to false. Use true if you want the user to be able to choose multiple files.
  # Returns an Array(String) of all files chosen, even if only 1, or nil upon canceling. Does not do any File IO.
  def self.open_file_dialog(*, title : String | Nil = nil, default : String | Nil = nil, filter_patterns : Array(String) | Nil = nil, description : String | Nil = nil, multiple_selects : Bool = false) : Array(String) | Nil
    pattern_size = filter_patterns.nil? ? 0 : filter_patterns.size
    filters = filter_patterns.nil? ? nil : filter_patterns.map(&.to_unsafe)
    if (result = Tinyfiledialogs.open_file_dialog(title, default, pattern_size, filters, description, multiple_selects.to_i)).null?
      nil
    else
      String.new(result).split("|")
    end
  end

  # Creates a select folder dialog.
  # Optional (title: String | Nil) defaults to nil.
  # Optional (default: String | Nil) defaults to nil. Determines default opening directory.
  # Returns a string of chosen folder, or nil upon canceling. Does not do any File IO.
  def self.select_folder_dialog(*, title : String | Nil = nil, default : String | Nil = nil) : String | Nil
    if (result = Tinyfiledialogs.select_folder_dialog(title, default)).null?
      nil
    else
      String.new(result)
    end
  end

  @@default_result_array : StaticArray(LibC::UChar, 3) = StaticArray[0_u8, 0_u8, 0_u8] # Default array used for when result_rgb in #color_chooser is nil.
  DEFAULT_RGB_ARRAY = StaticArray[0_u8, 128_u8, 255_u8] # Default rgb array used when both default_hex and default_rgb are nil in #color_chooser.

  # Creates a color choice dialog.
  # Optional (title: String | Nil) defaults to nil.
  # Optional (default_hex: String | Nil) defaults to nil. Determines the initial color of the color picker. Use nil if prefer to use default_rgb instead.
  # Optional (default_rgb: StaticArray(LibC::Uchar, 3)) defaults to StaticArray[0_u8, 128_u8, 255_u8]. Only used if default_hex is nil.
  # Optional (result_rgb: Pointer(StaticArray(LibC::Uchar,3)) | Nil) defaults to nil. This array is modified in place for the RGB of the chosen color.
  # When result_rgb is nil, FileDialog.color_results_rgb keeps track of the results of the latest color choice as a StaticArray regardless.
  # Returns a String representing the hexcode of the chosen color.
  def self.color_chooser(*, title : String | Nil = nil, default_hex : String | Nil = nil, default_rgb : StaticArray(LibC::UChar, 3) = DEFAULT_RGB_ARRAY, result_rgb : Pointer(StaticArray(LibC::UChar, 3)) | Nil = nil) : String | Nil
    if (result = Tinyfiledialogs.color_chooser(title, default_hex, default_rgb, result_rgb.nil? ? pointerof(@@default_result_array) : result_rgb)).null?
      nil
    else
      String.new(result)
    end
  end

  # The latest color_chooser result in RGB. Only updated when color_chooser is used and result_rgb is nil.
  # Returns StaticArray(LibC::UChar, 3).
  def self.color_results_rgb : StaticArray(LibC::UChar, 3)
    @@default_result_array
  end
end
