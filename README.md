# Install
```
cd flutter_mapbox_gps_realtime

flutter pub get

```

# Configurando (Android)
Vá até o diretório *android/app/src/main/AndroidManifest.xml*
e adicione as permissões abaixo:
```
<manifest...>

<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

No mesmo arquivo, adicione a meta com seu token do Mapbox:

```
<application ...>
        <meta-data android:name="com.mapbox.token" android:value="YOUR_TOKEN_MAPBOX" />
```

Por ultimo configure o Gandle para aceitar o SDKMinimo de 20.
Vá para *android/app/src/build.gradle*
```
defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        ...
        minSdkVersion 20
        ...
}
```

# Running
```
flutter run 
or
flutter run --profile (60 FPS)
```

# Features
* Localização em tempo real.
* Indicador da direção que o usuário está indo. 

# Prints
![](print.png)
