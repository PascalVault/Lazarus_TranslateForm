# Lazarus_TranslateForm
Translate your application to other languages, easily!

## Uwage example ##

    uses ..., Translator;
    
    procedure TForm1.OnCreate...
    begin
      TranslateForm('de', Form1); //translate to German
    end;
    
    procedure TForm1.OnDestroy...
    begin
      SaveOriginalTranslations('lang\original_text.txt'); //save text from your components to original_text.txt
    end;
`
Now when you have original_text.txt you just copy & paste its contents into a translation service (like Google Translate), translate to any language you want (for example German) and save the output as "de.txt". And now your application is ready for German speakers.

By default languages files are loaded by "lang" dir but you can change it with:

    SetTranlationDir("other dir") 
