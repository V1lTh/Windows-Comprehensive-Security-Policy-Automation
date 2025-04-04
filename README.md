- Descargar 4 archivos .zip
    https://www.microsoft.com/en-us/download/details.aspx?id=55319
        - Versión Windows 10/11/Server Baseline
        - PolicyAnalyzer.zip
        - LGPO.zip
            - SetObjectSecurity.zip (No explicado aun)

- Descomprimirlos, preferiblemente en una carpeta en común que este en raíz, como C: (Ya que al ejecutar en otra, suele dar error)

- Abrimos y ejecutamos PolicyAnalyzer_40.exe
    Usualmente sale una ventana con una lista vacía

- En la parte inferior de la Ventana, hay para elegir las carpetas de donde se encuentran
    los "Policy Rule" que por defecto esta en 'C:\Users\Usuario\Documents' lo cambiamos a gusto,
    pero en la carpeta misma de PolicyAnalyzer, encontraremos una que se llame '\PolicyAnalyzer_40\Policy Rules'
    se recomienda asignar ese.

- Seleccionamos la carpeta de Policy Rules, lo que nos saldra una lista de archivos que tienen
    como extensión '.PolicyRules'

- Ahora importaremos un nuevo archivo .PolicyRules:
    Con una carpeta que ha sido exportada pj, el baseline de la version de Windows que bajamos,
    para ello en 'Add', pestaña 'File', seleccionamos 'Add files from GPO(s)...'
    Vamos a la carpeta donde se encuentra el archivo 'Windows X vYHZ Security Baseline', lo seleccionamos,
    nos saldrá una serie de archivos que contiene la carpeta, damos a 'Importar', asignamos un nombre y
    guardamos el archivo en la carpeta de Policy Rules.
    Ahora en la lista de plantillas, nos aparecerá el archivo que acabamos de crear.

- Hemos importado la plantilla que se usara como referencia para comparar políticas,
    ahora debemos crear un nuevo archivo .PolicyRules de las políticas locales de la maquina, para ello
    ejecutamos como administrador PowerShell

    LGPO.exe /b \PolicyAnalyzer_40\Policy Rules\LocalGPO.PolicyRules
        LGPO.exe: Llama al ejecutable
        /b: Este parámetro indica que se desea exportar las políticas locales.
        \ruta: Esta es la ruta donde se guardara la carpeta con las políticas exportadas.

    Z:\POLICYANALIZER\LGPO_30\LGPO.exe /b "Z:\POLICYANALIZER\exports"

- Volvemos abrir PolicyAnalyzer, y en la pestaña 'Add', seleccionamos 'Add files from GPO', seleccionamos la carpeta
- Una vez ejecutado, exportara las políticas locales
    que se creo anteriormente, y el archivo lo guardamos en '.PolicyRules' con el nombre  a gusto

