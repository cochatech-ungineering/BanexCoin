## **Información de la Empresa**

**Empresa:** Banexcoin Bolivia  
 **Representante:** Lorena Alejandra Grundy Castaños  
 **Teléfono del representante:** 62602737  
 **Correo:** [informacion@banexcoin.com.bo](mailto:informacion@banexcoin.com.bo)

Banex Reintegra

### **Descripción del problema**

BanexReintegra es una solución diseñada por Banexcoin que busca incentivar el uso de pagos con QR mediante un sistema de reintegros (cashback) en USDT, basado en niveles de consumo mensual.

Actualmente, Banexcoin permite a los usuarios realizar pagos escaneando cualquier código QR del sistema financiero tradicional en Bolivia. Al realizar el pago:

- Al usuario se le debita el monto equivalente en USDT al tipo de cambio del momento
- El comercio recibe el pago en bolivianos (Bs.)
- La transacción es inmediata y sin comisiones

Esto permite a los usuarios ahorrar en criptoactivos estables como USDT sin perder la facilidad de pago en moneda local. El sistema de reintegros se realiza actualmente de forma manual y limitada a un grupo reducido de usuarios, lo que genera:

- Procesos operativos lentos y propensos a error
- Dificultad para escalar el beneficio a todos los usuarios
- Alta carga operativa para el equipo
- Falta de automatización en cálculos y reportes

¿Qué se necesita? Diseñar un sistema independiente que funcione a partir de la carga de reportes mensuales de transacciones QR y que permita:

1. Carga de datos: Subir archivos (CSV, Excel u otros) con el detalle de pagos QR de todos los usuarios
2. Procesamiento automático: Calcular el gasto total mensual por usuario. Clasificar automáticamente a los usuarios por niveles de consumo. Aplicar el porcentaje de reintegro correspondiente
3. Estructura de niveles (ejemplo)

Nivel 1: X monto – Y monto → 1% reintegro

Nivel 2: X monto – Y monto → 1.5% reintegro

Nivel 3: X monto – Y monto → 2% reintegro

4. Cálculo de reintegros

Determinar el monto de reintegro en:

- USDT
- Bolivianos (Bs.)

5. Generación de reportes: Exportar reportes listos para carga operativa que incluyan:

- Usuario
- Monto total consumido
- Nivel alcanzado
- Reintegro en USDT
- Reintegro en Bs.

6. Preparación para ejecución: Generar archivos compatibles para cargar pagos masivos mediante BanexTransfer (transferencias internas de USDT)

- Consideraciones clave
- El sistema debe ser 100% independiente, sin integración directa con el sistema actual de Banexcoin
- Debe funcionar únicamente a partir de archivos de datos cargados manualmente
- Debe ser escalable para futuros volúmenes masivos de usuarios
- Debe minimizar errores humanos

## **Información disponible para los equipos**

- Reportes de transacciones de pagos con QR por usuario
- Montos de consumo mensual en Bs. y su equivalente en USDT
- Tipo de cambio aplicado por transacción
- Identificación de usuarios (ID o cuenta)
- Estructura de niveles de reintegro (rangos y porcentajes definidos por Banexcoin)
