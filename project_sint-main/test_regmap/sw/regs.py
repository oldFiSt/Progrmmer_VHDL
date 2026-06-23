#!/usr/bin/env python3
# -*- coding: utf-8 -*-

""" Created with Corsair v1.0.4

Control/status register map.
"""


class _RegTest_rw_0:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_0_ADDR)
        return (rdata >> self._rmap.TEST_RW_0_DATA_POS) & self._rmap.TEST_RW_0_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_0_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_0_DATA_MSK << self._rmap.TEST_RW_0_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_0_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_0_ADDR, rdata)


class _RegTest_rw_1:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_1_ADDR)
        return (rdata >> self._rmap.TEST_RW_1_DATA_POS) & self._rmap.TEST_RW_1_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_1_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_1_DATA_MSK << self._rmap.TEST_RW_1_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_1_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_1_ADDR, rdata)


class _RegTest_rw_2:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_2_ADDR)
        return (rdata >> self._rmap.TEST_RW_2_DATA_POS) & self._rmap.TEST_RW_2_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_2_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_2_DATA_MSK << self._rmap.TEST_RW_2_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_2_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_2_ADDR, rdata)


class _RegTest_rw_3:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_3_ADDR)
        return (rdata >> self._rmap.TEST_RW_3_DATA_POS) & self._rmap.TEST_RW_3_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_3_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_3_DATA_MSK << self._rmap.TEST_RW_3_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_3_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_3_ADDR, rdata)


class _RegTest_rw_4:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_4_ADDR)
        return (rdata >> self._rmap.TEST_RW_4_DATA_POS) & self._rmap.TEST_RW_4_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_4_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_4_DATA_MSK << self._rmap.TEST_RW_4_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_4_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_4_ADDR, rdata)


class _RegTest_rw_5:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_5_ADDR)
        return (rdata >> self._rmap.TEST_RW_5_DATA_POS) & self._rmap.TEST_RW_5_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_5_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_5_DATA_MSK << self._rmap.TEST_RW_5_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_5_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_5_ADDR, rdata)


class _RegTest_rw_6:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_6_ADDR)
        return (rdata >> self._rmap.TEST_RW_6_DATA_POS) & self._rmap.TEST_RW_6_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_6_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_6_DATA_MSK << self._rmap.TEST_RW_6_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_6_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_6_ADDR, rdata)


class _RegTest_rw_7:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_7_ADDR)
        return (rdata >> self._rmap.TEST_RW_7_DATA_POS) & self._rmap.TEST_RW_7_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_7_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_7_DATA_MSK << self._rmap.TEST_RW_7_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_7_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_7_ADDR, rdata)


class _RegTest_rw_8:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_8_ADDR)
        return (rdata >> self._rmap.TEST_RW_8_DATA_POS) & self._rmap.TEST_RW_8_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_8_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_8_DATA_MSK << self._rmap.TEST_RW_8_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_8_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_8_ADDR, rdata)


class _RegTest_rw_9:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_9_ADDR)
        return (rdata >> self._rmap.TEST_RW_9_DATA_POS) & self._rmap.TEST_RW_9_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_9_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_9_DATA_MSK << self._rmap.TEST_RW_9_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_9_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_9_ADDR, rdata)


class _RegTest_rw_10:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_10_ADDR)
        return (rdata >> self._rmap.TEST_RW_10_DATA_POS) & self._rmap.TEST_RW_10_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_10_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_10_DATA_MSK << self._rmap.TEST_RW_10_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_10_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_10_ADDR, rdata)


class _RegTest_rw_11:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_11_ADDR)
        return (rdata >> self._rmap.TEST_RW_11_DATA_POS) & self._rmap.TEST_RW_11_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_11_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_11_DATA_MSK << self._rmap.TEST_RW_11_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_11_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_11_ADDR, rdata)


class _RegTest_rw_12:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_12_ADDR)
        return (rdata >> self._rmap.TEST_RW_12_DATA_POS) & self._rmap.TEST_RW_12_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_12_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_12_DATA_MSK << self._rmap.TEST_RW_12_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_12_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_12_ADDR, rdata)


class _RegTest_rw_13:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_13_ADDR)
        return (rdata >> self._rmap.TEST_RW_13_DATA_POS) & self._rmap.TEST_RW_13_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_13_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_13_DATA_MSK << self._rmap.TEST_RW_13_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_13_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_13_ADDR, rdata)


class _RegTest_rw_14:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_14_ADDR)
        return (rdata >> self._rmap.TEST_RW_14_DATA_POS) & self._rmap.TEST_RW_14_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_14_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_14_DATA_MSK << self._rmap.TEST_RW_14_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_14_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_14_ADDR, rdata)


class _RegTest_rw_15:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_RW_15_ADDR)
        return (rdata >> self._rmap.TEST_RW_15_DATA_POS) & self._rmap.TEST_RW_15_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_RW_15_ADDR)
        rdata = rdata & (~(self._rmap.TEST_RW_15_DATA_MSK << self._rmap.TEST_RW_15_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_RW_15_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_RW_15_ADDR, rdata)


class _RegTest_w_0:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_0_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_0_DATA_MSK << self._rmap.TEST_W_0_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_0_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_0_ADDR, rdata)


class _RegTest_w_1:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_1_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_1_DATA_MSK << self._rmap.TEST_W_1_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_1_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_1_ADDR, rdata)


class _RegTest_w_2:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_2_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_2_DATA_MSK << self._rmap.TEST_W_2_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_2_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_2_ADDR, rdata)


class _RegTest_w_3:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_3_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_3_DATA_MSK << self._rmap.TEST_W_3_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_3_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_3_ADDR, rdata)


class _RegTest_w_4:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_4_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_4_DATA_MSK << self._rmap.TEST_W_4_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_4_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_4_ADDR, rdata)


class _RegTest_w_5:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_5_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_5_DATA_MSK << self._rmap.TEST_W_5_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_5_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_5_ADDR, rdata)


class _RegTest_w_6:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_6_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_6_DATA_MSK << self._rmap.TEST_W_6_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_6_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_6_ADDR, rdata)


class _RegTest_w_7:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_7_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_7_DATA_MSK << self._rmap.TEST_W_7_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_7_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_7_ADDR, rdata)


class _RegTest_w_8:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_8_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_8_DATA_MSK << self._rmap.TEST_W_8_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_8_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_8_ADDR, rdata)


class _RegTest_w_9:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_9_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_9_DATA_MSK << self._rmap.TEST_W_9_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_9_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_9_ADDR, rdata)


class _RegTest_w_10:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_10_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_10_DATA_MSK << self._rmap.TEST_W_10_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_10_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_10_ADDR, rdata)


class _RegTest_w_11:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_11_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_11_DATA_MSK << self._rmap.TEST_W_11_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_11_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_11_ADDR, rdata)


class _RegTest_w_12:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_12_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_12_DATA_MSK << self._rmap.TEST_W_12_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_12_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_12_ADDR, rdata)


class _RegTest_w_13:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_13_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_13_DATA_MSK << self._rmap.TEST_W_13_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_13_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_13_ADDR, rdata)


class _RegTest_w_14:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_14_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_14_DATA_MSK << self._rmap.TEST_W_14_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_14_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_14_ADDR, rdata)


class _RegTest_w_15:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        return 0

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TEST_W_15_ADDR)
        rdata = rdata & (~(self._rmap.TEST_W_15_DATA_MSK << self._rmap.TEST_W_15_DATA_POS))
        rdata = rdata | (val << self._rmap.TEST_W_15_DATA_POS)
        self._rmap._if.write(self._rmap.TEST_W_15_ADDR, rdata)


class _RegTest_r_0:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_0_ADDR)
        return (rdata >> self._rmap.TEST_R_0_DATA_POS) & self._rmap.TEST_R_0_DATA_MSK


class _RegTest_r_1:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_1_ADDR)
        return (rdata >> self._rmap.TEST_R_1_DATA_POS) & self._rmap.TEST_R_1_DATA_MSK


class _RegTest_r_2:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_2_ADDR)
        return (rdata >> self._rmap.TEST_R_2_DATA_POS) & self._rmap.TEST_R_2_DATA_MSK


class _RegTest_r_3:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_3_ADDR)
        return (rdata >> self._rmap.TEST_R_3_DATA_POS) & self._rmap.TEST_R_3_DATA_MSK


class _RegTest_r_4:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_4_ADDR)
        return (rdata >> self._rmap.TEST_R_4_DATA_POS) & self._rmap.TEST_R_4_DATA_MSK


class _RegTest_r_5:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_5_ADDR)
        return (rdata >> self._rmap.TEST_R_5_DATA_POS) & self._rmap.TEST_R_5_DATA_MSK


class _RegTest_r_6:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_6_ADDR)
        return (rdata >> self._rmap.TEST_R_6_DATA_POS) & self._rmap.TEST_R_6_DATA_MSK


class _RegTest_r_7:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_7_ADDR)
        return (rdata >> self._rmap.TEST_R_7_DATA_POS) & self._rmap.TEST_R_7_DATA_MSK


class _RegTest_r_8:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_8_ADDR)
        return (rdata >> self._rmap.TEST_R_8_DATA_POS) & self._rmap.TEST_R_8_DATA_MSK


class _RegTest_r_9:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_9_ADDR)
        return (rdata >> self._rmap.TEST_R_9_DATA_POS) & self._rmap.TEST_R_9_DATA_MSK


class _RegTest_r_10:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_10_ADDR)
        return (rdata >> self._rmap.TEST_R_10_DATA_POS) & self._rmap.TEST_R_10_DATA_MSK


class _RegTest_r_11:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_11_ADDR)
        return (rdata >> self._rmap.TEST_R_11_DATA_POS) & self._rmap.TEST_R_11_DATA_MSK


class _RegTest_r_12:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_12_ADDR)
        return (rdata >> self._rmap.TEST_R_12_DATA_POS) & self._rmap.TEST_R_12_DATA_MSK


class _RegTest_r_13:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_13_ADDR)
        return (rdata >> self._rmap.TEST_R_13_DATA_POS) & self._rmap.TEST_R_13_DATA_MSK


class _RegTest_r_14:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_14_ADDR)
        return (rdata >> self._rmap.TEST_R_14_DATA_POS) & self._rmap.TEST_R_14_DATA_MSK


class _RegTest_r_15:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Test data field"""
        rdata = self._rmap._if.read(self._rmap.TEST_R_15_ADDR)
        return (rdata >> self._rmap.TEST_R_15_DATA_POS) & self._rmap.TEST_R_15_DATA_MSK


class RegMap:
    """Control/Status register map"""

    # TEST_RW_0 - Test register RW 0
    TEST_RW_0_ADDR = 0x0000
    TEST_RW_0_DATA_POS = 0
    TEST_RW_0_DATA_MSK = 0xffffffff

    # TEST_RW_1 - Test register RW 1
    TEST_RW_1_ADDR = 0x0004
    TEST_RW_1_DATA_POS = 0
    TEST_RW_1_DATA_MSK = 0xffffffff

    # TEST_RW_2 - Test register RW 2
    TEST_RW_2_ADDR = 0x0008
    TEST_RW_2_DATA_POS = 0
    TEST_RW_2_DATA_MSK = 0xffffffff

    # TEST_RW_3 - Test register RW 3
    TEST_RW_3_ADDR = 0x000c
    TEST_RW_3_DATA_POS = 0
    TEST_RW_3_DATA_MSK = 0xffffffff

    # TEST_RW_4 - Test register RW 4
    TEST_RW_4_ADDR = 0x0010
    TEST_RW_4_DATA_POS = 0
    TEST_RW_4_DATA_MSK = 0xffffffff

    # TEST_RW_5 - Test register RW 5
    TEST_RW_5_ADDR = 0x0014
    TEST_RW_5_DATA_POS = 0
    TEST_RW_5_DATA_MSK = 0xffffffff

    # TEST_RW_6 - Test register RW 6
    TEST_RW_6_ADDR = 0x0018
    TEST_RW_6_DATA_POS = 0
    TEST_RW_6_DATA_MSK = 0xffffffff

    # TEST_RW_7 - Test register RW 7
    TEST_RW_7_ADDR = 0x001c
    TEST_RW_7_DATA_POS = 0
    TEST_RW_7_DATA_MSK = 0xffffffff

    # TEST_RW_8 - Test register RW 8
    TEST_RW_8_ADDR = 0x0020
    TEST_RW_8_DATA_POS = 0
    TEST_RW_8_DATA_MSK = 0xffffffff

    # TEST_RW_9 - Test register RW 9
    TEST_RW_9_ADDR = 0x0024
    TEST_RW_9_DATA_POS = 0
    TEST_RW_9_DATA_MSK = 0xffffffff

    # TEST_RW_10 - Test register RW 10
    TEST_RW_10_ADDR = 0x0028
    TEST_RW_10_DATA_POS = 0
    TEST_RW_10_DATA_MSK = 0xffffffff

    # TEST_RW_11 - Test register RW 11
    TEST_RW_11_ADDR = 0x002c
    TEST_RW_11_DATA_POS = 0
    TEST_RW_11_DATA_MSK = 0xffffffff

    # TEST_RW_12 - Test register RW 12
    TEST_RW_12_ADDR = 0x0030
    TEST_RW_12_DATA_POS = 0
    TEST_RW_12_DATA_MSK = 0xffffffff

    # TEST_RW_13 - Test register RW 13
    TEST_RW_13_ADDR = 0x0034
    TEST_RW_13_DATA_POS = 0
    TEST_RW_13_DATA_MSK = 0xffffffff

    # TEST_RW_14 - Test register RW 14
    TEST_RW_14_ADDR = 0x0038
    TEST_RW_14_DATA_POS = 0
    TEST_RW_14_DATA_MSK = 0xffffffff

    # TEST_RW_15 - Test register RW 15
    TEST_RW_15_ADDR = 0x003c
    TEST_RW_15_DATA_POS = 0
    TEST_RW_15_DATA_MSK = 0xffffffff

    # TEST_W_0 - Test register W 0
    TEST_W_0_ADDR = 0x0040
    TEST_W_0_DATA_POS = 0
    TEST_W_0_DATA_MSK = 0xffffffff

    # TEST_W_1 - Test register W 1
    TEST_W_1_ADDR = 0x0044
    TEST_W_1_DATA_POS = 0
    TEST_W_1_DATA_MSK = 0xffffffff

    # TEST_W_2 - Test register W 2
    TEST_W_2_ADDR = 0x0048
    TEST_W_2_DATA_POS = 0
    TEST_W_2_DATA_MSK = 0xffffffff

    # TEST_W_3 - Test register W 3
    TEST_W_3_ADDR = 0x004c
    TEST_W_3_DATA_POS = 0
    TEST_W_3_DATA_MSK = 0xffffffff

    # TEST_W_4 - Test register W 4
    TEST_W_4_ADDR = 0x0050
    TEST_W_4_DATA_POS = 0
    TEST_W_4_DATA_MSK = 0xffffffff

    # TEST_W_5 - Test register W 5
    TEST_W_5_ADDR = 0x0054
    TEST_W_5_DATA_POS = 0
    TEST_W_5_DATA_MSK = 0xffffffff

    # TEST_W_6 - Test register W 6
    TEST_W_6_ADDR = 0x0058
    TEST_W_6_DATA_POS = 0
    TEST_W_6_DATA_MSK = 0xffffffff

    # TEST_W_7 - Test register W 7
    TEST_W_7_ADDR = 0x005c
    TEST_W_7_DATA_POS = 0
    TEST_W_7_DATA_MSK = 0xffffffff

    # TEST_W_8 - Test register W 8
    TEST_W_8_ADDR = 0x0060
    TEST_W_8_DATA_POS = 0
    TEST_W_8_DATA_MSK = 0xffffffff

    # TEST_W_9 - Test register W 9
    TEST_W_9_ADDR = 0x0064
    TEST_W_9_DATA_POS = 0
    TEST_W_9_DATA_MSK = 0xffffffff

    # TEST_W_10 - Test register W 10
    TEST_W_10_ADDR = 0x0068
    TEST_W_10_DATA_POS = 0
    TEST_W_10_DATA_MSK = 0xffffffff

    # TEST_W_11 - Test register W 11
    TEST_W_11_ADDR = 0x006c
    TEST_W_11_DATA_POS = 0
    TEST_W_11_DATA_MSK = 0xffffffff

    # TEST_W_12 - Test register W 12
    TEST_W_12_ADDR = 0x0070
    TEST_W_12_DATA_POS = 0
    TEST_W_12_DATA_MSK = 0xffffffff

    # TEST_W_13 - Test register W 13
    TEST_W_13_ADDR = 0x0074
    TEST_W_13_DATA_POS = 0
    TEST_W_13_DATA_MSK = 0xffffffff

    # TEST_W_14 - Test register W 14
    TEST_W_14_ADDR = 0x0078
    TEST_W_14_DATA_POS = 0
    TEST_W_14_DATA_MSK = 0xffffffff

    # TEST_W_15 - Test register W 15
    TEST_W_15_ADDR = 0x007c
    TEST_W_15_DATA_POS = 0
    TEST_W_15_DATA_MSK = 0xffffffff

    # TEST_R_0 - Test register R 0
    TEST_R_0_ADDR = 0x0080
    TEST_R_0_DATA_POS = 0
    TEST_R_0_DATA_MSK = 0xffffffff

    # TEST_R_1 - Test register R 1
    TEST_R_1_ADDR = 0x0084
    TEST_R_1_DATA_POS = 0
    TEST_R_1_DATA_MSK = 0xffffffff

    # TEST_R_2 - Test register R 2
    TEST_R_2_ADDR = 0x0088
    TEST_R_2_DATA_POS = 0
    TEST_R_2_DATA_MSK = 0xffffffff

    # TEST_R_3 - Test register R 3
    TEST_R_3_ADDR = 0x008c
    TEST_R_3_DATA_POS = 0
    TEST_R_3_DATA_MSK = 0xffffffff

    # TEST_R_4 - Test register R 4
    TEST_R_4_ADDR = 0x0090
    TEST_R_4_DATA_POS = 0
    TEST_R_4_DATA_MSK = 0xffffffff

    # TEST_R_5 - Test register R 5
    TEST_R_5_ADDR = 0x0094
    TEST_R_5_DATA_POS = 0
    TEST_R_5_DATA_MSK = 0xffffffff

    # TEST_R_6 - Test register R 6
    TEST_R_6_ADDR = 0x0098
    TEST_R_6_DATA_POS = 0
    TEST_R_6_DATA_MSK = 0xffffffff

    # TEST_R_7 - Test register R 7
    TEST_R_7_ADDR = 0x009c
    TEST_R_7_DATA_POS = 0
    TEST_R_7_DATA_MSK = 0xffffffff

    # TEST_R_8 - Test register R 8
    TEST_R_8_ADDR = 0x00a0
    TEST_R_8_DATA_POS = 0
    TEST_R_8_DATA_MSK = 0xffffffff

    # TEST_R_9 - Test register R 9
    TEST_R_9_ADDR = 0x00a4
    TEST_R_9_DATA_POS = 0
    TEST_R_9_DATA_MSK = 0xffffffff

    # TEST_R_10 - Test register R 10
    TEST_R_10_ADDR = 0x00a8
    TEST_R_10_DATA_POS = 0
    TEST_R_10_DATA_MSK = 0xffffffff

    # TEST_R_11 - Test register R 11
    TEST_R_11_ADDR = 0x00ac
    TEST_R_11_DATA_POS = 0
    TEST_R_11_DATA_MSK = 0xffffffff

    # TEST_R_12 - Test register R 12
    TEST_R_12_ADDR = 0x00b0
    TEST_R_12_DATA_POS = 0
    TEST_R_12_DATA_MSK = 0xffffffff

    # TEST_R_13 - Test register R 13
    TEST_R_13_ADDR = 0x00b4
    TEST_R_13_DATA_POS = 0
    TEST_R_13_DATA_MSK = 0xffffffff

    # TEST_R_14 - Test register R 14
    TEST_R_14_ADDR = 0x00b8
    TEST_R_14_DATA_POS = 0
    TEST_R_14_DATA_MSK = 0xffffffff

    # TEST_R_15 - Test register R 15
    TEST_R_15_ADDR = 0x00bc
    TEST_R_15_DATA_POS = 0
    TEST_R_15_DATA_MSK = 0xffffffff

    def __init__(self, interface):
        self._if = interface

    @property
    def test_rw_0(self):
        """Test register RW 0"""
        return self._if.read(self.TEST_RW_0_ADDR)

    @test_rw_0.setter
    def test_rw_0(self, val):
        self._if.write(self.TEST_RW_0_ADDR, val)

    @property
    def test_rw_0_bf(self):
        return _RegTest_rw_0(self)

    @property
    def test_rw_1(self):
        """Test register RW 1"""
        return self._if.read(self.TEST_RW_1_ADDR)

    @test_rw_1.setter
    def test_rw_1(self, val):
        self._if.write(self.TEST_RW_1_ADDR, val)

    @property
    def test_rw_1_bf(self):
        return _RegTest_rw_1(self)

    @property
    def test_rw_2(self):
        """Test register RW 2"""
        return self._if.read(self.TEST_RW_2_ADDR)

    @test_rw_2.setter
    def test_rw_2(self, val):
        self._if.write(self.TEST_RW_2_ADDR, val)

    @property
    def test_rw_2_bf(self):
        return _RegTest_rw_2(self)

    @property
    def test_rw_3(self):
        """Test register RW 3"""
        return self._if.read(self.TEST_RW_3_ADDR)

    @test_rw_3.setter
    def test_rw_3(self, val):
        self._if.write(self.TEST_RW_3_ADDR, val)

    @property
    def test_rw_3_bf(self):
        return _RegTest_rw_3(self)

    @property
    def test_rw_4(self):
        """Test register RW 4"""
        return self._if.read(self.TEST_RW_4_ADDR)

    @test_rw_4.setter
    def test_rw_4(self, val):
        self._if.write(self.TEST_RW_4_ADDR, val)

    @property
    def test_rw_4_bf(self):
        return _RegTest_rw_4(self)

    @property
    def test_rw_5(self):
        """Test register RW 5"""
        return self._if.read(self.TEST_RW_5_ADDR)

    @test_rw_5.setter
    def test_rw_5(self, val):
        self._if.write(self.TEST_RW_5_ADDR, val)

    @property
    def test_rw_5_bf(self):
        return _RegTest_rw_5(self)

    @property
    def test_rw_6(self):
        """Test register RW 6"""
        return self._if.read(self.TEST_RW_6_ADDR)

    @test_rw_6.setter
    def test_rw_6(self, val):
        self._if.write(self.TEST_RW_6_ADDR, val)

    @property
    def test_rw_6_bf(self):
        return _RegTest_rw_6(self)

    @property
    def test_rw_7(self):
        """Test register RW 7"""
        return self._if.read(self.TEST_RW_7_ADDR)

    @test_rw_7.setter
    def test_rw_7(self, val):
        self._if.write(self.TEST_RW_7_ADDR, val)

    @property
    def test_rw_7_bf(self):
        return _RegTest_rw_7(self)

    @property
    def test_rw_8(self):
        """Test register RW 8"""
        return self._if.read(self.TEST_RW_8_ADDR)

    @test_rw_8.setter
    def test_rw_8(self, val):
        self._if.write(self.TEST_RW_8_ADDR, val)

    @property
    def test_rw_8_bf(self):
        return _RegTest_rw_8(self)

    @property
    def test_rw_9(self):
        """Test register RW 9"""
        return self._if.read(self.TEST_RW_9_ADDR)

    @test_rw_9.setter
    def test_rw_9(self, val):
        self._if.write(self.TEST_RW_9_ADDR, val)

    @property
    def test_rw_9_bf(self):
        return _RegTest_rw_9(self)

    @property
    def test_rw_10(self):
        """Test register RW 10"""
        return self._if.read(self.TEST_RW_10_ADDR)

    @test_rw_10.setter
    def test_rw_10(self, val):
        self._if.write(self.TEST_RW_10_ADDR, val)

    @property
    def test_rw_10_bf(self):
        return _RegTest_rw_10(self)

    @property
    def test_rw_11(self):
        """Test register RW 11"""
        return self._if.read(self.TEST_RW_11_ADDR)

    @test_rw_11.setter
    def test_rw_11(self, val):
        self._if.write(self.TEST_RW_11_ADDR, val)

    @property
    def test_rw_11_bf(self):
        return _RegTest_rw_11(self)

    @property
    def test_rw_12(self):
        """Test register RW 12"""
        return self._if.read(self.TEST_RW_12_ADDR)

    @test_rw_12.setter
    def test_rw_12(self, val):
        self._if.write(self.TEST_RW_12_ADDR, val)

    @property
    def test_rw_12_bf(self):
        return _RegTest_rw_12(self)

    @property
    def test_rw_13(self):
        """Test register RW 13"""
        return self._if.read(self.TEST_RW_13_ADDR)

    @test_rw_13.setter
    def test_rw_13(self, val):
        self._if.write(self.TEST_RW_13_ADDR, val)

    @property
    def test_rw_13_bf(self):
        return _RegTest_rw_13(self)

    @property
    def test_rw_14(self):
        """Test register RW 14"""
        return self._if.read(self.TEST_RW_14_ADDR)

    @test_rw_14.setter
    def test_rw_14(self, val):
        self._if.write(self.TEST_RW_14_ADDR, val)

    @property
    def test_rw_14_bf(self):
        return _RegTest_rw_14(self)

    @property
    def test_rw_15(self):
        """Test register RW 15"""
        return self._if.read(self.TEST_RW_15_ADDR)

    @test_rw_15.setter
    def test_rw_15(self, val):
        self._if.write(self.TEST_RW_15_ADDR, val)

    @property
    def test_rw_15_bf(self):
        return _RegTest_rw_15(self)

    @property
    def test_w_0(self):
        """Test register W 0"""
        return 0

    @test_w_0.setter
    def test_w_0(self, val):
        self._if.write(self.TEST_W_0_ADDR, val)

    @property
    def test_w_0_bf(self):
        return _RegTest_w_0(self)

    @property
    def test_w_1(self):
        """Test register W 1"""
        return 0

    @test_w_1.setter
    def test_w_1(self, val):
        self._if.write(self.TEST_W_1_ADDR, val)

    @property
    def test_w_1_bf(self):
        return _RegTest_w_1(self)

    @property
    def test_w_2(self):
        """Test register W 2"""
        return 0

    @test_w_2.setter
    def test_w_2(self, val):
        self._if.write(self.TEST_W_2_ADDR, val)

    @property
    def test_w_2_bf(self):
        return _RegTest_w_2(self)

    @property
    def test_w_3(self):
        """Test register W 3"""
        return 0

    @test_w_3.setter
    def test_w_3(self, val):
        self._if.write(self.TEST_W_3_ADDR, val)

    @property
    def test_w_3_bf(self):
        return _RegTest_w_3(self)

    @property
    def test_w_4(self):
        """Test register W 4"""
        return 0

    @test_w_4.setter
    def test_w_4(self, val):
        self._if.write(self.TEST_W_4_ADDR, val)

    @property
    def test_w_4_bf(self):
        return _RegTest_w_4(self)

    @property
    def test_w_5(self):
        """Test register W 5"""
        return 0

    @test_w_5.setter
    def test_w_5(self, val):
        self._if.write(self.TEST_W_5_ADDR, val)

    @property
    def test_w_5_bf(self):
        return _RegTest_w_5(self)

    @property
    def test_w_6(self):
        """Test register W 6"""
        return 0

    @test_w_6.setter
    def test_w_6(self, val):
        self._if.write(self.TEST_W_6_ADDR, val)

    @property
    def test_w_6_bf(self):
        return _RegTest_w_6(self)

    @property
    def test_w_7(self):
        """Test register W 7"""
        return 0

    @test_w_7.setter
    def test_w_7(self, val):
        self._if.write(self.TEST_W_7_ADDR, val)

    @property
    def test_w_7_bf(self):
        return _RegTest_w_7(self)

    @property
    def test_w_8(self):
        """Test register W 8"""
        return 0

    @test_w_8.setter
    def test_w_8(self, val):
        self._if.write(self.TEST_W_8_ADDR, val)

    @property
    def test_w_8_bf(self):
        return _RegTest_w_8(self)

    @property
    def test_w_9(self):
        """Test register W 9"""
        return 0

    @test_w_9.setter
    def test_w_9(self, val):
        self._if.write(self.TEST_W_9_ADDR, val)

    @property
    def test_w_9_bf(self):
        return _RegTest_w_9(self)

    @property
    def test_w_10(self):
        """Test register W 10"""
        return 0

    @test_w_10.setter
    def test_w_10(self, val):
        self._if.write(self.TEST_W_10_ADDR, val)

    @property
    def test_w_10_bf(self):
        return _RegTest_w_10(self)

    @property
    def test_w_11(self):
        """Test register W 11"""
        return 0

    @test_w_11.setter
    def test_w_11(self, val):
        self._if.write(self.TEST_W_11_ADDR, val)

    @property
    def test_w_11_bf(self):
        return _RegTest_w_11(self)

    @property
    def test_w_12(self):
        """Test register W 12"""
        return 0

    @test_w_12.setter
    def test_w_12(self, val):
        self._if.write(self.TEST_W_12_ADDR, val)

    @property
    def test_w_12_bf(self):
        return _RegTest_w_12(self)

    @property
    def test_w_13(self):
        """Test register W 13"""
        return 0

    @test_w_13.setter
    def test_w_13(self, val):
        self._if.write(self.TEST_W_13_ADDR, val)

    @property
    def test_w_13_bf(self):
        return _RegTest_w_13(self)

    @property
    def test_w_14(self):
        """Test register W 14"""
        return 0

    @test_w_14.setter
    def test_w_14(self, val):
        self._if.write(self.TEST_W_14_ADDR, val)

    @property
    def test_w_14_bf(self):
        return _RegTest_w_14(self)

    @property
    def test_w_15(self):
        """Test register W 15"""
        return 0

    @test_w_15.setter
    def test_w_15(self, val):
        self._if.write(self.TEST_W_15_ADDR, val)

    @property
    def test_w_15_bf(self):
        return _RegTest_w_15(self)

    @property
    def test_r_0(self):
        """Test register R 0"""
        return self._if.read(self.TEST_R_0_ADDR)

    @property
    def test_r_0_bf(self):
        return _RegTest_r_0(self)

    @property
    def test_r_1(self):
        """Test register R 1"""
        return self._if.read(self.TEST_R_1_ADDR)

    @property
    def test_r_1_bf(self):
        return _RegTest_r_1(self)

    @property
    def test_r_2(self):
        """Test register R 2"""
        return self._if.read(self.TEST_R_2_ADDR)

    @property
    def test_r_2_bf(self):
        return _RegTest_r_2(self)

    @property
    def test_r_3(self):
        """Test register R 3"""
        return self._if.read(self.TEST_R_3_ADDR)

    @property
    def test_r_3_bf(self):
        return _RegTest_r_3(self)

    @property
    def test_r_4(self):
        """Test register R 4"""
        return self._if.read(self.TEST_R_4_ADDR)

    @property
    def test_r_4_bf(self):
        return _RegTest_r_4(self)

    @property
    def test_r_5(self):
        """Test register R 5"""
        return self._if.read(self.TEST_R_5_ADDR)

    @property
    def test_r_5_bf(self):
        return _RegTest_r_5(self)

    @property
    def test_r_6(self):
        """Test register R 6"""
        return self._if.read(self.TEST_R_6_ADDR)

    @property
    def test_r_6_bf(self):
        return _RegTest_r_6(self)

    @property
    def test_r_7(self):
        """Test register R 7"""
        return self._if.read(self.TEST_R_7_ADDR)

    @property
    def test_r_7_bf(self):
        return _RegTest_r_7(self)

    @property
    def test_r_8(self):
        """Test register R 8"""
        return self._if.read(self.TEST_R_8_ADDR)

    @property
    def test_r_8_bf(self):
        return _RegTest_r_8(self)

    @property
    def test_r_9(self):
        """Test register R 9"""
        return self._if.read(self.TEST_R_9_ADDR)

    @property
    def test_r_9_bf(self):
        return _RegTest_r_9(self)

    @property
    def test_r_10(self):
        """Test register R 10"""
        return self._if.read(self.TEST_R_10_ADDR)

    @property
    def test_r_10_bf(self):
        return _RegTest_r_10(self)

    @property
    def test_r_11(self):
        """Test register R 11"""
        return self._if.read(self.TEST_R_11_ADDR)

    @property
    def test_r_11_bf(self):
        return _RegTest_r_11(self)

    @property
    def test_r_12(self):
        """Test register R 12"""
        return self._if.read(self.TEST_R_12_ADDR)

    @property
    def test_r_12_bf(self):
        return _RegTest_r_12(self)

    @property
    def test_r_13(self):
        """Test register R 13"""
        return self._if.read(self.TEST_R_13_ADDR)

    @property
    def test_r_13_bf(self):
        return _RegTest_r_13(self)

    @property
    def test_r_14(self):
        """Test register R 14"""
        return self._if.read(self.TEST_R_14_ADDR)

    @property
    def test_r_14_bf(self):
        return _RegTest_r_14(self)

    @property
    def test_r_15(self):
        """Test register R 15"""
        return self._if.read(self.TEST_R_15_ADDR)

    @property
    def test_r_15_bf(self):
        return _RegTest_r_15(self)
