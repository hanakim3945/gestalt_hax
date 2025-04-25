```jsx
DeviceTypeDeviceIdentity *__cdecl -[DeviceTypeDeviceIdentity init](DeviceTypeDeviceIdentity *self, SEL a2)
{
  DeviceTypeDeviceIdentity *v2; // x19
  id v3; // x20
  id v4; // x21
  NSString *v5; // x0
  NSString *product_type; // x8
  id v7; // x21
  NSString *v8; // x0
  NSString *hardware_model; // x8
  id v10; // x21
  NSString *v11; // x0
  NSString *device_class; // x8
  id v13; // x21
  id v14; // x23
  id v15; // x21
  id v16; // x22
  id v17; // x21
  id v18; // x28
  id v19; // x21
  id v20; // x24
  id v21; // x21
  id v22; // x25
  id v23; // x26
  id v24; // x21
  id v25; // x27
  id v26; // x21
  unsigned int v27; // w23
  id v28; // x24
  id v29; // x21
  unsigned int v30; // w23
  id v31; // x21
  id v32; // x28
  id v33; // x21
  id v34; // x23
  id v35; // x25
  unsigned int v36; // w26
  void *v37; // x21
  id v39; // [xsp+0h] [xbp-80h]
  id v40; // [xsp+8h] [xbp-78h]
  id v41; // [xsp+10h] [xbp-70h]
  id v42; // [xsp+18h] [xbp-68h]
  objc_super v43; // [xsp+20h] [xbp-60h] BYREF

  v43.receiver = self;
  v43.super_class = (Class)&OBJC_CLASS___DeviceTypeDeviceIdentity;
  v2 = -[NSObject init](&v43, sel_init);
  if ( v2 )
  {
    v2->_is_internal_build = os_variant_allows_internal_security_policies(objc_msgSend(CFSTR("com.apple.mobileactivationd"), sel_UTF8String));
    v2->_has_internal_diagnostics = os_variant_has_internal_diagnostics(objc_msgSend(CFSTR("com.apple.mobileactivationd"), sel_UTF8String));
    v3 = objc_retainAutoreleasedReturnValue(
           +[GestaltHlprDeviceIdentity getSharedInstance](
             &OBJC_CLASS___GestaltHlprDeviceIdentity,
             sel_getSharedInstance));
    v4 = objc_msgSend(v3, sel_copyAnswer_, CFSTR("ProductType"));
    v5 = (NSString *)objc_retainAutoreleasedReturnValue((id)isNSString());
    product_type = v2->_product_type;
    v2->_product_type = v5;
    objc_release(product_type);
    objc_release(v4);
    v7 = objc_msgSend(v3, sel_copyAnswer_, CFSTR("HWModelStr"));
    v8 = (NSString *)objc_retainAutoreleasedReturnValue((id)isNSString());
    hardware_model = v2->_hardware_model;
    v2->_hardware_model = v8;
    objc_release(hardware_model);
    objc_release(v7);
    v2->_is_ipod = -[NSString hasPrefix:](v2->_product_type, sel_hasPrefix_, CFSTR("iPod"));
    v2->_is_ipad = -[NSString hasPrefix:](v2->_product_type, sel_hasPrefix_, CFSTR("iPad"));
    v2->_is_audio_accessory = -[NSString hasPrefix:](v2->_product_type, sel_hasPrefix_, CFSTR("AudioAccessory"));
    v2->_is_dev_board = -[NSString hasSuffix:](v2->_hardware_model, sel_hasSuffix_, CFSTR("DEV"));
    v10 = objc_msgSend(v3, sel_copyAnswer_, CFSTR("DeviceClass"));
    v11 = (NSString *)objc_retainAutoreleasedReturnValue((id)isNSString());
    device_class = v2->_device_class;
    v2->_device_class = v11;
    objc_release(device_class);
    objc_release(v10);
    v2->_has_telephony = (unsigned __int8)objc_msgSend(v3, sel_getBoolAnswer_, CFSTR("HasBaseband"));
    v2->_device_supports_dcrt_oob = (unsigned __int8)objc_msgSend(
                                                       v3,
                                                       sel_getBoolAnswer_,
                                                       CFSTR("DeviceSupportsFairPlaySecureVideoPath"));
    v13 = objc_retainAutoreleasedReturnValue(objc_msgSend(CFSTR("IODeviceTree"), sel_stringByAppendingString_, CFSTR(":/product")));
    v14 = -[DeviceTypeDeviceIdentity copyDeviceTreeInt:key:defaultValue:](
            v2,
            sel_copyDeviceTreeInt_key_defaultValue_,
            v13,
            CFSTR("allow-hactivation"),
            0LL);
    objc_release(v13);
    v15 = objc_msgSend(v3, sel_copyAnswer_, CFSTR("CertificateProductionStatus"));
    v16 = objc_retainAutoreleasedReturnValue((id)((__int64 (*)(void))isNSNumber)());
    objc_release(v15);
    v17 = objc_msgSend(v3, sel_copyAnswer_, CFSTR("EffectiveProductionStatusAp"));
    v18 = objc_retainAutoreleasedReturnValue((id)((__int64 (*)(void))isNSNumber)());
    objc_release(v17);
    v19 = objc_msgSend(v3, sel_copyAnswer_, CFSTR("CertificateSecurityMode"));
    v20 = objc_retainAutoreleasedReturnValue((id)((__int64 (*)(void))isNSNumber)());
    objc_release(v19);
    v21 = objc_msgSend(v3, sel_copyAnswer_, CFSTR("EffectiveSecurityModeSEP"));
    v22 = objc_retainAutoreleasedReturnValue((id)((__int64 (*)(void))isNSNumber)());
    objc_release(v21);
    if ( v20 && v16 && v18 && v22 )
    {
      if ( (unsigned int)objc_msgSend(v16, sel_isEqualToNumber_, &unk_1F33EFD18)
        && (unsigned int)objc_msgSend(v18, sel_isEqualToNumber_, &unk_1F33EFD30)
        && (unsigned int)objc_msgSend(v20, sel_isEqualToNumber_, &unk_1F33EFD18)
        && (unsigned int)objc_msgSend(v22, sel_isEqualToNumber_, &unk_1F33EFD18) )
      {
        v2->_should_hactivate = 1;
        v2->_is_prodfused_demoted = 1;
      }
      if ( (unsigned int)objc_msgSend(v16, sel_isEqualToNumber_, &unk_1F33EFD30)
        && (unsigned int)objc_msgSend(v18, sel_isEqualToNumber_, &unk_1F33EFD30)
        && (unsigned int)objc_msgSend(v20, sel_isEqualToNumber_, &unk_1F33EFD18)
        && (unsigned int)objc_msgSend(v22, sel_isEqualToNumber_, &unk_1F33EFD18) )
      {
        v2->_should_hactivate = 1;
        v2->_is_devfused_undemoted = 1;
      }
    }
    if ( v2->_is_internal_build )
    {
      if ( !v2->_should_hactivate )
        v2->_should_hactivate = (unsigned __int8)objc_msgSend(v3, sel_getBoolAnswer_, CFSTR("ShouldHactivate"));
      v23 = -[DeviceTypeDeviceIdentity copyBootArgs](v2, sel_copyBootArgs);
      v24 = objc_retainAutoreleasedReturnValue(unk_1F3404030(&off_1F3404900, sel_whitespaceCharacterSet));
      v39 = v23;
      v25 = objc_retainAutoreleasedReturnValue(objc_msgSend(v23, sel_componentsSeparatedByCharactersInSet_, v24));
      objc_release(v24);
      if ( -[NSString containsString:](v2->_product_type, sel_containsString_, CFSTR("iFPGA")) )
      {
        v2->_should_hactivate = 1;
        v2->_is_fpga = 1;
      }
      if ( v2->_is_dev_board )
        v2->_should_hactivate = 1;
      v26 = objc_retainAutoreleasedReturnValue((id)isNSNumber(v14));
      v40 = v14;
      if ( v26 )
      {
        v27 = (unsigned int)objc_msgSend(v14, sel_boolValue);
        objc_release(v26);
        if ( v27 )
          v2->_should_hactivate = 1;
      }
      else
      {
        objc_release(0LL);
      }
      v42 = v20;
      if ( (unsigned int)objc_msgSend(v25, sel_containsObject_, CFSTR("disable-hactivation-ma=1")) )
        v2->_should_hactivate = 0;
      v28 = v22;
      v41 = v18;
      v29 = objc_retainAutoreleasedReturnValue(unk_1F33F80B0(&off_1F33FA0F0, sel_defaultManager));
      v30 = (unsigned int)objc_msgSend(v29, sel_fileExistsAtPath_, CFSTR("/AppleInternal/Lockdown/.hactivateoff"));
      objc_release(v29);
      if ( v30 )
        v2->_should_hactivate = 0;
      v31 = objc_alloc((Class)&off_1F3404D48);
      v32 = objc_retainAutoreleasedReturnValue(objc_msgSend(v31, sel_persistentDomainForName_, CFSTR("com.apple.mobileactivationd")));
      objc_release(v31);
      v33 = objc_retainAutoreleasedReturnValue(objc_msgSend(v32, sel_objectForKeyedSubscript_, CFSTR("DisableHactivation")));
      v34 = objc_retainAutoreleasedReturnValue((id)isNSNumber(v33));
      if ( v34 )
      {
        v35 = objc_retainAutoreleasedReturnValue(objc_msgSend(v32, sel_objectForKeyedSubscript_, CFSTR("DisableHactivation")));
        v36 = (unsigned int)objc_msgSend(v35, sel_boolValue);
        objc_release(v35);
        objc_release(v34);
        objc_release(v33);
        v37 = v39;
        v14 = v40;
        v22 = v28;
        if ( v36 )
          v2->_should_hactivate = 0;
      }
      else
      {
        objc_release(0LL);
        objc_release(v33);
        v37 = v23;
        v14 = v40;
      }
      objc_release(v25);
      objc_release(v37);
      objc_release(v32);
      v18 = v41;
      v20 = v42;
    }
    objc_release(v14);
    objc_release(v20);
    objc_release(v22);
    objc_release(v18);
    objc_release(v16);
    objc_release(v3);
  }
  return v2;
}
```
