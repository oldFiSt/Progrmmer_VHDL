# Register map

Created with [Corsair](https://github.com/esynr3z/corsair) v1.0.4.

## Conventions

| Access mode | Description               |
| :---------- | :------------------------ |
| rw          | Read and Write            |
| rw1c        | Read and Write 1 to Clear |
| rw1s        | Read and Write 1 to Set   |
| ro          | Read Only                 |
| roc         | Read Only to Clear        |
| roll        | Read Only / Latch Low     |
| rolh        | Read Only / Latch High    |
| wo          | Write only                |
| wosc        | Write Only / Self Clear   |

## Register map summary

Base address: 0x00000000

| Name                     | Address    | Description |
| :---                     | :---       | :---        |
| [TEST_RW_0](#test_rw_0)  | 0x0000     | Test register RW 0 |
| [TEST_RW_1](#test_rw_1)  | 0x0004     | Test register RW 1 |
| [TEST_RW_2](#test_rw_2)  | 0x0008     | Test register RW 2 |
| [TEST_RW_3](#test_rw_3)  | 0x000c     | Test register RW 3 |
| [TEST_RW_4](#test_rw_4)  | 0x0010     | Test register RW 4 |
| [TEST_RW_5](#test_rw_5)  | 0x0014     | Test register RW 5 |
| [TEST_RW_6](#test_rw_6)  | 0x0018     | Test register RW 6 |
| [TEST_RW_7](#test_rw_7)  | 0x001c     | Test register RW 7 |
| [TEST_RW_8](#test_rw_8)  | 0x0020     | Test register RW 8 |
| [TEST_RW_9](#test_rw_9)  | 0x0024     | Test register RW 9 |
| [TEST_RW_10](#test_rw_10) | 0x0028     | Test register RW 10 |
| [TEST_RW_11](#test_rw_11) | 0x002c     | Test register RW 11 |
| [TEST_RW_12](#test_rw_12) | 0x0030     | Test register RW 12 |
| [TEST_RW_13](#test_rw_13) | 0x0034     | Test register RW 13 |
| [TEST_RW_14](#test_rw_14) | 0x0038     | Test register RW 14 |
| [TEST_RW_15](#test_rw_15) | 0x003c     | Test register RW 15 |
| [TEST_W_0](#test_w_0)    | 0x0040     | Test register W 0 |
| [TEST_W_1](#test_w_1)    | 0x0044     | Test register W 1 |
| [TEST_W_2](#test_w_2)    | 0x0048     | Test register W 2 |
| [TEST_W_3](#test_w_3)    | 0x004c     | Test register W 3 |
| [TEST_W_4](#test_w_4)    | 0x0050     | Test register W 4 |
| [TEST_W_5](#test_w_5)    | 0x0054     | Test register W 5 |
| [TEST_W_6](#test_w_6)    | 0x0058     | Test register W 6 |
| [TEST_W_7](#test_w_7)    | 0x005c     | Test register W 7 |
| [TEST_W_8](#test_w_8)    | 0x0060     | Test register W 8 |
| [TEST_W_9](#test_w_9)    | 0x0064     | Test register W 9 |
| [TEST_W_10](#test_w_10)  | 0x0068     | Test register W 10 |
| [TEST_W_11](#test_w_11)  | 0x006c     | Test register W 11 |
| [TEST_W_12](#test_w_12)  | 0x0070     | Test register W 12 |
| [TEST_W_13](#test_w_13)  | 0x0074     | Test register W 13 |
| [TEST_W_14](#test_w_14)  | 0x0078     | Test register W 14 |
| [TEST_W_15](#test_w_15)  | 0x007c     | Test register W 15 |
| [TEST_R_0](#test_r_0)    | 0x0080     | Test register R 0 |
| [TEST_R_1](#test_r_1)    | 0x0084     | Test register R 1 |
| [TEST_R_2](#test_r_2)    | 0x0088     | Test register R 2 |
| [TEST_R_3](#test_r_3)    | 0x008c     | Test register R 3 |
| [TEST_R_4](#test_r_4)    | 0x0090     | Test register R 4 |
| [TEST_R_5](#test_r_5)    | 0x0094     | Test register R 5 |
| [TEST_R_6](#test_r_6)    | 0x0098     | Test register R 6 |
| [TEST_R_7](#test_r_7)    | 0x009c     | Test register R 7 |
| [TEST_R_8](#test_r_8)    | 0x00a0     | Test register R 8 |
| [TEST_R_9](#test_r_9)    | 0x00a4     | Test register R 9 |
| [TEST_R_10](#test_r_10)  | 0x00a8     | Test register R 10 |
| [TEST_R_11](#test_r_11)  | 0x00ac     | Test register R 11 |
| [TEST_R_12](#test_r_12)  | 0x00b0     | Test register R 12 |
| [TEST_R_13](#test_r_13)  | 0x00b4     | Test register R 13 |
| [TEST_R_14](#test_r_14)  | 0x00b8     | Test register R 14 |
| [TEST_R_15](#test_r_15)  | 0x00bc     | Test register R 15 |

## TEST_RW_0

Test register RW 0

Address offset: 0x0000

Reset value: 0x00000000

![test_rw_0](md_img/test_rw_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_1

Test register RW 1

Address offset: 0x0004

Reset value: 0x00000000

![test_rw_1](md_img/test_rw_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_2

Test register RW 2

Address offset: 0x0008

Reset value: 0x00000000

![test_rw_2](md_img/test_rw_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_3

Test register RW 3

Address offset: 0x000c

Reset value: 0x00000000

![test_rw_3](md_img/test_rw_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_4

Test register RW 4

Address offset: 0x0010

Reset value: 0x00000000

![test_rw_4](md_img/test_rw_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_5

Test register RW 5

Address offset: 0x0014

Reset value: 0x00000000

![test_rw_5](md_img/test_rw_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_6

Test register RW 6

Address offset: 0x0018

Reset value: 0x00000000

![test_rw_6](md_img/test_rw_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_7

Test register RW 7

Address offset: 0x001c

Reset value: 0x00000000

![test_rw_7](md_img/test_rw_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_8

Test register RW 8

Address offset: 0x0020

Reset value: 0x00000000

![test_rw_8](md_img/test_rw_8.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_9

Test register RW 9

Address offset: 0x0024

Reset value: 0x00000000

![test_rw_9](md_img/test_rw_9.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_10

Test register RW 10

Address offset: 0x0028

Reset value: 0x00000000

![test_rw_10](md_img/test_rw_10.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_11

Test register RW 11

Address offset: 0x002c

Reset value: 0x00000000

![test_rw_11](md_img/test_rw_11.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_12

Test register RW 12

Address offset: 0x0030

Reset value: 0x00000000

![test_rw_12](md_img/test_rw_12.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_13

Test register RW 13

Address offset: 0x0034

Reset value: 0x00000000

![test_rw_13](md_img/test_rw_13.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_14

Test register RW 14

Address offset: 0x0038

Reset value: 0x00000000

![test_rw_14](md_img/test_rw_14.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_RW_15

Test register RW 15

Address offset: 0x003c

Reset value: 0x00000000

![test_rw_15](md_img/test_rw_15.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | rw              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_0

Test register W 0

Address offset: 0x0040

Reset value: 0x00000000

![test_w_0](md_img/test_w_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_1

Test register W 1

Address offset: 0x0044

Reset value: 0x00000000

![test_w_1](md_img/test_w_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_2

Test register W 2

Address offset: 0x0048

Reset value: 0x00000000

![test_w_2](md_img/test_w_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_3

Test register W 3

Address offset: 0x004c

Reset value: 0x00000000

![test_w_3](md_img/test_w_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_4

Test register W 4

Address offset: 0x0050

Reset value: 0x00000000

![test_w_4](md_img/test_w_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_5

Test register W 5

Address offset: 0x0054

Reset value: 0x00000000

![test_w_5](md_img/test_w_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_6

Test register W 6

Address offset: 0x0058

Reset value: 0x00000000

![test_w_6](md_img/test_w_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_7

Test register W 7

Address offset: 0x005c

Reset value: 0x00000000

![test_w_7](md_img/test_w_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_8

Test register W 8

Address offset: 0x0060

Reset value: 0x00000000

![test_w_8](md_img/test_w_8.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_9

Test register W 9

Address offset: 0x0064

Reset value: 0x00000000

![test_w_9](md_img/test_w_9.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_10

Test register W 10

Address offset: 0x0068

Reset value: 0x00000000

![test_w_10](md_img/test_w_10.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_11

Test register W 11

Address offset: 0x006c

Reset value: 0x00000000

![test_w_11](md_img/test_w_11.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_12

Test register W 12

Address offset: 0x0070

Reset value: 0x00000000

![test_w_12](md_img/test_w_12.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_13

Test register W 13

Address offset: 0x0074

Reset value: 0x00000000

![test_w_13](md_img/test_w_13.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_14

Test register W 14

Address offset: 0x0078

Reset value: 0x00000000

![test_w_14](md_img/test_w_14.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_W_15

Test register W 15

Address offset: 0x007c

Reset value: 0x00000000

![test_w_15](md_img/test_w_15.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | wo              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_0

Test register R 0

Address offset: 0x0080

Reset value: 0x00000000

![test_r_0](md_img/test_r_0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_1

Test register R 1

Address offset: 0x0084

Reset value: 0x00000000

![test_r_1](md_img/test_r_1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_2

Test register R 2

Address offset: 0x0088

Reset value: 0x00000000

![test_r_2](md_img/test_r_2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_3

Test register R 3

Address offset: 0x008c

Reset value: 0x00000000

![test_r_3](md_img/test_r_3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_4

Test register R 4

Address offset: 0x0090

Reset value: 0x00000000

![test_r_4](md_img/test_r_4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_5

Test register R 5

Address offset: 0x0094

Reset value: 0x00000000

![test_r_5](md_img/test_r_5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_6

Test register R 6

Address offset: 0x0098

Reset value: 0x00000000

![test_r_6](md_img/test_r_6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_7

Test register R 7

Address offset: 0x009c

Reset value: 0x00000000

![test_r_7](md_img/test_r_7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_8

Test register R 8

Address offset: 0x00a0

Reset value: 0x00000000

![test_r_8](md_img/test_r_8.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_9

Test register R 9

Address offset: 0x00a4

Reset value: 0x00000000

![test_r_9](md_img/test_r_9.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_10

Test register R 10

Address offset: 0x00a8

Reset value: 0x00000000

![test_r_10](md_img/test_r_10.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_11

Test register R 11

Address offset: 0x00ac

Reset value: 0x00000000

![test_r_11](md_img/test_r_11.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_12

Test register R 12

Address offset: 0x00b0

Reset value: 0x00000000

![test_r_12](md_img/test_r_12.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_13

Test register R 13

Address offset: 0x00b4

Reset value: 0x00000000

![test_r_13](md_img/test_r_13.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_14

Test register R 14

Address offset: 0x00b8

Reset value: 0x00000000

![test_r_14](md_img/test_r_14.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).

## TEST_R_15

Test register R 15

Address offset: 0x00bc

Reset value: 0x00000000

![test_r_15](md_img/test_r_15.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| data             | 31:0   | ro              | 0x00000000 | Test data field |

Back to [Register map](#register-map-summary).
