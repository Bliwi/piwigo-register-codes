# Version 1.3 Early Release. A plugin for Piwigo that requires users to have a code for registration. Codes can be set to expire or to a defined number of uses.
# Major Fixes (1.25+1.3):
    Experimental logging and correction for uses count inaccuracy potential
    Fixed expiry TIMESTAMP from 0000-00-00 format and switched to NULL to add MySQL 8 native support
    Backend Code Updates for efficiency and scalability
    Code Generate/Copy Buttons, Batch Code Generator
    Lots of visual improvements and more tpl usage
# Notes:
    Does not keep codes between activations
# to do:
    Failing a registration (email/user in use, etc) can count towards uses of a code even though unsuccessful over-all. Need to find way to trigger on success to only count at that time.
    Add History Logging Feature
    Translations, trying to build with it in mind but currently have no translations.
# Shout Outs:
    foundation-datepicker used from https://github.com/najlepsiwebdesigner/foundation-datepicker
    Version 1.25 includes huge contributions from Bliwi on Github. Added code generate/copy buttons, a batch code generator and plenty of visual improvements.
