{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 9,
      "minor": 1,
      "revision": 4,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      -299.0,
      -851.0,
      872.0,
      658.0
    ],
    "openrect": [
      0.0,
      0.0,
      0.0,
      169.0
    ],
    "openrectmode": 0,
    "openinpresentation": 1,
    "boxanimatetime": 500,
    "boxes": [
      {
        "box": {
          "fontsize": 10.0,
          "id": "obj-34",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            330.0,
            107.0,
            128.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            13.45832972228527,
            149.13612508773804,
            41.35782343149185,
            18.0
          ],
          "text": "Octave"
        }
      },
      {
        "box": {
          "fontsize": 10.0,
          "id": "obj-33",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            315.0,
            92.0,
            129.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            13.45832972228527,
            105.0674419105053,
            30.043893665075302,
            18.0
          ],
          "text": "Tone"
        }
      },
      {
        "box": {
          "fontsize": 10.0,
          "id": "obj-32",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            315.0,
            92.0,
            132.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            23.58467760682106,
            69.23076966404915,
            32.0,
            18.0
          ],
          "text": "High"
        }
      },
      {
        "box": {
          "fontsize": 10.0,
          "id": "obj-31",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            300.0,
            77.0,
            131.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            23.58467760682106,
            48.416289895772934,
            28.0,
            18.0
          ],
          "text": "Low"
        }
      },
      {
        "box": {
          "fontsize": 10.0,
          "id": "obj-19",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            300.0,
            77.0,
            127.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            90.58015322685242,
            16.28959286212921,
            61.0,
            18.0
          ],
          "text": "Mute track"
        }
      },
      {
        "box": {
          "fontsize": 10.0,
          "id": "obj-16",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            285.0,
            62.0,
            128.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            24.06431570649147,
            16.28959286212921,
            55.0,
            18.0
          ],
          "text": "Bypass fx"
        }
      },
      {
        "box": {
          "fontface": 0,
          "fontsize": 8.0,
          "id": "obj-14",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            285.0,
            62.0,
            109.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            6.212551802396774,
            36.00452500581741,
            33.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "textcolor": {
              "expression": "themecolor.live_control_fg"
            }
          },
          "text": "Limits"
        }
      },
      {
        "box": {
          "fontface": 0,
          "fontsize": 8.0,
          "id": "obj-30",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            270.0,
            47.0,
            113.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            5.712551802396774,
            4.720647215843201,
            34.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "textcolor": {
              "expression": "themecolor.live_control_fg"
            }
          },
          "text": "Global"
        }
      },
      {
        "box": {
          "id": "obj-1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "int"
          ],
          "patching_rect": [
            30.0,
            30.0,
            45.0,
            22.0
          ],
          "text": "midiin"
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 8,
          "outlettype": [
            "",
            "",
            "",
            "int",
            "int",
            "",
            "int",
            ""
          ],
          "patching_rect": [
            30.0,
            80.0,
            62.0,
            22.0
          ],
          "text": "midiparse"
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 9,
          "outlettype": [
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ],
          "patching_rect": [
            30.0,
            360.0,
            90.0,
            22.0
          ],
          "saved_object_attributes": {
            "filename": "zone.js",
            "parameter_enable": 0
          },
          "text": "js zone.js"
        }
      },
      {
        "box": {
          "id": "obj-4",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 2,
          "outlettype": [
            "int",
            ""
          ],
          "patching_rect": [
            200.0,
            300.0,
            66.0,
            22.0
          ],
          "text": "midiformat"
        }
      },
      {
        "box": {
          "id": "obj-5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            30.0,
            440.0,
            50.0,
            22.0
          ],
          "text": "midiout"
        }
      },
      {
        "box": {
          "id": "obj-13",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400.0,
            40.0,
            24.0,
            24.0
          ],
          "presentation": 1,
          "presentation_rect": [
            10.48965498805046,
            19.004525005817413,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_longname": "bypass",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Bypass",
              "parameter_type": 2
            }
          },
          "varname": "bypass"
        }
      },
      {
        "box": {
          "id": "obj-12",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400.0,
            70.0,
            24.0,
            24.0
          ],
          "presentation": 1,
          "presentation_rect": [
            77.00549250841141,
            19.004525005817413,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_longname": "mute",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Mute",
              "parameter_type": 2
            }
          },
          "varname": "mute"
        }
      },
      {
        "box": {
          "id": "obj-6",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400.0,
            100.0,
            24.0,
            24.0
          ],
          "presentation": 1,
          "presentation_rect": [
            11.819971650838852,
            49.321267277002335,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_longname": "loOn",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Lo on",
              "parameter_type": 2
            }
          },
          "varname": "loOn"
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "live.button",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            640.0,
            100.0,
            20.0,
            20.0
          ],
          "presentation": 1,
          "presentation_rect": [
            94.17291334271431,
            48.868778586387634,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_longname": "learnLo",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Learn Lo",
              "parameter_type": 2
            }
          },
          "varname": "learnLo"
        }
      },
      {
        "box": {
          "id": "obj-7",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "float"
          ],
          "parameter_enable": 1,
          "patching_rect": [
            440.0,
            100.0,
            60.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            67.92856928706169,
            49.321267277002335,
            24.227268636226654,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "loNote",
              "parameter_modmode": 0,
              "parameter_shortname": "Low",
              "parameter_type": 1,
              "parameter_unitstyle": 0
            }
          },
          "textjustification": 2,
          "varname": "loNote"
        }
      },
      {
        "box": {
          "bgcolor": [
            0.0,
            0.0,
            0.0,
            0.0
          ],
          "fontsize": 10.0,
          "id": "obj-60",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            520.0,
            100.0,
            41.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            47.11408951878548,
            47.51131251454353,
            34.264177441596985,
            18.0
          ],
          "saved_attribute_attributes": {
            "textcolor": {
              "expression": "themecolor.live_prelisten"
            }
          },
          "text": "C-2",
          "textcolor": [
            0.10196078431372549,
            0.49019607843137253,
            0.9450980392156862,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-8",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400.0,
            130.0,
            24.0,
            24.0
          ],
          "presentation": 1,
          "presentation_rect": [
            11.819971650838852,
            71.04072442650795,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_longname": "hiOn",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Hi on",
              "parameter_type": 2
            }
          },
          "varname": "hiOn"
        }
      },
      {
        "box": {
          "id": "obj-18",
          "maxclass": "live.button",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            640.0,
            100.0,
            20.0,
            20.0
          ],
          "presentation": 1,
          "presentation_rect": [
            94.17291334271431,
            71.04072442650795,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_longname": "learnHi",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Learn Hi",
              "parameter_type": 2
            }
          },
          "varname": "learnHi"
        }
      },
      {
        "box": {
          "id": "obj-9",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "float"
          ],
          "parameter_enable": 1,
          "patching_rect": [
            440.0,
            130.0,
            60.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            67.92856928706169,
            71.04072442650795,
            24.227268636226654,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                127
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "hiNote",
              "parameter_modmode": 0,
              "parameter_shortname": "High",
              "parameter_type": 1,
              "parameter_unitstyle": 0
            }
          },
          "textjustification": 2,
          "varname": "hiNote"
        }
      },
      {
        "box": {
          "bgcolor": [
            0.6470588235294118,
            0.6470588235294118,
            0.6470588235294118,
            1.0
          ],
          "fontsize": 10.0,
          "id": "obj-61",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            520.0,
            100.0,
            41.0,
            18.0
          ],
          "presentation": 1,
          "presentation_rect": [
            47.11408951878548,
            69.23076966404915,
            29.21348547935486,
            18.0
          ],
          "saved_attribute_attributes": {
            "textcolor": {
              "expression": "themecolor.live_prelisten"
            }
          },
          "text": "G3",
          "textcolor": [
            0.10196078431372549,
            0.49019607843137253,
            0.9450980392156862,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-10",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "float"
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400.0,
            160.0,
            60.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            50.49681457877159,
            150.63612508773804,
            19.797169238328934,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "octave",
              "parameter_mmax": 4.0,
              "parameter_mmin": -4.0,
              "parameter_modmode": 0,
              "parameter_shortname": "Octave",
              "parameter_type": 1,
              "parameter_unitstyle": 0
            }
          },
          "varname": "octave"
        }
      },
      {
        "box": {
          "id": "obj-11",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "float"
          ],
          "parameter_enable": 1,
          "patching_rect": [
            440.0,
            160.0,
            60.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            42.099868416786194,
            106.5674419105053,
            18.623481392860413,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "semitone",
              "parameter_mmax": 5.0,
              "parameter_mmin": -6.0,
              "parameter_modmode": 0,
              "parameter_shortname": "Tone",
              "parameter_type": 1,
              "parameter_unitstyle": 0
            }
          },
          "varname": "semitone"
        }
      },
      {
        "box": {
          "bgcolor": [
            0.0,
            0.0,
            0.0,
            0.0
          ],
          "fontface": 2,
          "fontsize": 9.0,
          "id": "obj-46",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            520.0,
            160.0,
            44.0,
            17.0
          ],
          "presentation": 1,
          "presentation_rect": [
            104.58015322685242,
            48.868778586387634,
            33.0,
            17.0
          ],
          "saved_attribute_attributes": {
            "textcolor": {
              "expression": "themecolor.live_meter_bg"
            }
          },
          "text": "learn",
          "textcolor": [
            0.050980392156862744,
            0.050980392156862744,
            0.050980392156862744,
            1.0
          ],
          "textjustification": 1
        }
      },
      {
        "box": {
          "bgcolor": [
            0.0,
            0.0,
            0.0,
            0.0
          ],
          "fontface": 2,
          "fontsize": 9.0,
          "id": "obj-47",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            520.0,
            190.0,
            44.0,
            17.0
          ],
          "presentation": 1,
          "presentation_rect": [
            104.58015322685242,
            70.13574704527855,
            33.0,
            17.0
          ],
          "saved_attribute_attributes": {
            "textcolor": {
              "expression": "themecolor.live_contrast_frame"
            }
          },
          "text": "learn",
          "textcolor": [
            0.20784313725490197,
            0.20784313725490197,
            0.20784313725490197,
            1.0
          ],
          "textjustification": 1
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            170.0,
            110.0,
            22.0
          ],
          "text": "prepend loon"
        }
      },
      {
        "box": {
          "id": "obj-21",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            196.0,
            110.0,
            22.0
          ],
          "text": "prepend lo"
        }
      },
      {
        "box": {
          "id": "obj-22",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            222.0,
            110.0,
            22.0
          ],
          "text": "prepend hion"
        }
      },
      {
        "box": {
          "id": "obj-23",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            248.0,
            110.0,
            22.0
          ],
          "text": "prepend hi"
        }
      },
      {
        "box": {
          "id": "obj-24",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            274.0,
            110.0,
            22.0
          ],
          "text": "prepend octaven"
        }
      },
      {
        "box": {
          "id": "obj-25",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            300.0,
            110.0,
            22.0
          ],
          "text": "prepend semin"
        }
      },
      {
        "box": {
          "id": "obj-26",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            326.0,
            110.0,
            22.0
          ],
          "text": "prepend muteon"
        }
      },
      {
        "box": {
          "id": "obj-27",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            352.0,
            110.0,
            22.0
          ],
          "text": "prepend bypasson"
        }
      },
      {
        "box": {
          "id": "obj-28",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            378.0,
            110.0,
            22.0
          ],
          "text": "prepend learnlo"
        }
      },
      {
        "box": {
          "id": "obj-29",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            404.0,
            110.0,
            22.0
          ],
          "text": "prepend learnhi"
        }
      },
      {
        "box": {
          "id": "obj-50",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            640.0,
            300.0,
            75.0,
            22.0
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-51",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            640.0,
            340.0,
            75.0,
            22.0
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "bgcolor": [
            0.0,
            0.0,
            0.0,
            0.0
          ],
          "fontface": 0,
          "fontsize": 8.0,
          "id": "obj-15",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            300.0,
            77.0,
            106.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            6.08467760682106,
            88.04072442650795,
            67.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "textcolor": {
              "expression": "themecolor.live_control_fg"
            }
          },
          "style": "comment001",
          "text": "Post Transpose"
        }
      },
      {
        "box": {
          "id": "obj-62",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "float"
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400.0,
            190.0,
            60.0,
            15.0
          ],
          "presentation": 1,
          "presentation_rect": [
            62.71055445075035,
            124.37914589047432,
            24.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                102
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "ctlCC",
              "parameter_modmode": 0,
              "parameter_shortname": "Tone CC",
              "parameter_type": 1,
              "parameter_unitstyle": 0
            }
          },
          "varname": "ctlCC"
        }
      },
      {
        "box": {
          "id": "obj-64",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400.0,
            220.0,
            24.0,
            24.0
          ],
          "presentation": 1,
          "presentation_rect": [
            89.23918929696083,
            115.5216229557991,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "0",
                "64"
              ],
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "ctlCenter",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Center",
              "parameter_type": 2
            }
          },
          "varname": "ctlCenter"
        }
      },
      {
        "box": {
          "id": "obj-65",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            440.0,
            220.0,
            24.0,
            24.0
          ],
          "presentation": 1,
          "presentation_rect": [
            90.0025480389595,
            134.35113859176636,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "All",
                "Step"
              ],
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "ctlRange",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Range",
              "parameter_type": 2
            }
          },
          "varname": "ctlRange"
        }
      },
      {
        "box": {
          "id": "obj-66",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            250.0,
            120.0,
            22.0
          ],
          "text": "prepend ctlnum"
        }
      },
      {
        "box": {
          "id": "obj-68",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            306.0,
            120.0,
            22.0
          ],
          "text": "prepend ctlcenter"
        }
      },
      {
        "box": {
          "id": "obj-69",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400.0,
            334.0,
            120.0,
            22.0
          ],
          "text": "prepend ctlrange"
        }
      },
      {
        "box": {
          "id": "obj-70",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            150.0,
            120.0,
            78.0,
            22.0
          ],
          "text": "prepend ctl"
        }
      },
      {
        "box": {
          "id": "obj-71",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            150.0,
            150.0,
            86.0,
            22.0
          ],
          "text": "prepend chan"
        }
      },
      {
        "box": {
          "fontsize": 9.0,
          "id": "obj-76",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            540.0,
            394.0,
            80.0,
            17.0
          ],
          "presentation": 1,
          "presentation_rect": [
            101.9618349969387,
            114.50381129980087,
            49.61831822991371,
            17.0
          ],
          "text": "Around 64"
        }
      },
      {
        "box": {
          "fontsize": 9.0,
          "id": "obj-77",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            540.0,
            394.0,
            80.0,
            17.0
          ],
          "presentation": 1,
          "presentation_rect": [
            102.21628791093826,
            133.33332693576813,
            44.0,
            17.0
          ],
          "text": "Step"
        }
      },
      {
        "box": {
          "id": "obj-78",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            360.0,
            220.0,
            24.0,
            24.0
          ],
          "presentation": 1,
          "presentation_rect": [
            20.98027655482292,
            124.37914589047432,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "ccOn",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "CC on",
              "parameter_type": 2
            }
          },
          "varname": "ccOn"
        }
      },
      {
        "box": {
          "id": "obj-79",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            360.0,
            258.0,
            90.0,
            22.0
          ],
          "text": "prepend ccon"
        }
      },
      {
        "box": {
          "fontsize": 9.0,
          "id": "obj-80",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            540.0,
            360.0,
            60.0,
            17.0
          ],
          "presentation": 1,
          "presentation_rect": [
            33.19401642680168,
            123.36133423447609,
            34.0,
            17.0
          ],
          "text": "on CC"
        }
      },
      {
        "box": {
          "id": "obj-81",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            360,
            250,
            24,
            24
          ],
          "presentation": 1,
          "presentation_rect": [
            80.0,
            150.6,
            15.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "octCcOn",
              "parameter_mmax": 1,
              "parameter_modmode": 0,
              "parameter_shortname": "Oct on",
              "parameter_type": 2
            }
          },
          "varname": "octCcOn"
        }
      },
      {
        "box": {
          "id": "obj-82",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "float"
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400,
            250,
            60,
            15
          ],
          "presentation": 1,
          "presentation_rect": [
            124.0,
            150.6,
            24.0,
            15.0
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                103
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "octCtlNum",
              "parameter_modmode": 0,
              "parameter_shortname": "Oct CC",
              "parameter_type": 1,
              "parameter_unitstyle": 0,
              "parameter_mmin": 0.0,
              "parameter_mmax": 127.0
            }
          },
          "varname": "octCtlNum"
        }
      },
      {
        "box": {
          "id": "obj-83",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            360,
            285,
            120,
            22
          ],
          "text": "prepend octccon"
        }
      },
      {
        "box": {
          "id": "obj-84",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400,
            285,
            120,
            22
          ],
          "text": "prepend octctlnum"
        }
      },
      {
        "box": {
          "id": "obj-85",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            540,
            400,
            40,
            18
          ],
          "presentation": 1,
          "presentation_rect": [
            93.0,
            149.6,
            34.0,
            15.0
          ],
          "text": "on CC",
          "fontsize": 9.0
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "destination": [
            "obj-2",
            0
          ],
          "source": [
            "obj-1",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-24",
            0
          ],
          "source": [
            "obj-10",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-25",
            0
          ],
          "source": [
            "obj-11",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-26",
            0
          ],
          "source": [
            "obj-12",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-27",
            0
          ],
          "source": [
            "obj-13",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-28",
            0
          ],
          "source": [
            "obj-17",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-29",
            0
          ],
          "source": [
            "obj-18",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-2",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-4",
            6
          ],
          "order": 0,
          "source": [
            "obj-2",
            6
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-4",
            5
          ],
          "source": [
            "obj-2",
            5
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-4",
            4
          ],
          "source": [
            "obj-2",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-4",
            3
          ],
          "source": [
            "obj-2",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-4",
            1
          ],
          "source": [
            "obj-2",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-70",
            0
          ],
          "source": [
            "obj-2",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-71",
            0
          ],
          "order": 1,
          "source": [
            "obj-2",
            6
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-20",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-21",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-22",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-23",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-25",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-26",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-27",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-28",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-29",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-11",
            0
          ],
          "source": [
            "obj-3",
            7
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-46",
            0
          ],
          "source": [
            "obj-3",
            5
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-47",
            0
          ],
          "source": [
            "obj-3",
            6
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-5",
            0
          ],
          "source": [
            "obj-3",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-50",
            0
          ],
          "source": [
            "obj-3",
            1
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-51",
            0
          ],
          "source": [
            "obj-3",
            2
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-60",
            0
          ],
          "source": [
            "obj-3",
            3
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-61",
            0
          ],
          "source": [
            "obj-3",
            4
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-5",
            0
          ],
          "source": [
            "obj-4",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-7",
            0
          ],
          "source": [
            "obj-50",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-9",
            0
          ],
          "source": [
            "obj-51",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-20",
            0
          ],
          "source": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-66",
            0
          ],
          "source": [
            "obj-62",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-68",
            0
          ],
          "source": [
            "obj-64",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-69",
            0
          ],
          "source": [
            "obj-65",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-66",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-68",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-69",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-21",
            0
          ],
          "source": [
            "obj-7",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-70",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-71",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-79",
            0
          ],
          "source": [
            "obj-78",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-3",
            0
          ],
          "source": [
            "obj-79",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-22",
            0
          ],
          "source": [
            "obj-8",
            0
          ]
        }
      },
      {
        "patchline": {
          "destination": [
            "obj-23",
            0
          ],
          "source": [
            "obj-9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-81",
            0
          ],
          "destination": [
            "obj-83",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-83",
            0
          ],
          "destination": [
            "obj-3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-82",
            0
          ],
          "destination": [
            "obj-84",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-84",
            0
          ],
          "destination": [
            "obj-3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-3",
            8
          ],
          "destination": [
            "obj-10",
            0
          ]
        }
      }
    ],
    "parameters": {
      "obj-10": [
        "hiNote",
        "Octave",
        0
      ],
      "obj-11": [
        "learnHi",
        "Tone",
        0
      ],
      "obj-12": [
        "mute",
        "Mute",
        0
      ],
      "obj-13": [
        "bypass",
        "Bypass",
        0
      ],
      "obj-17": [
        "learnLo[1]",
        "Learn Lo",
        0
      ],
      "obj-18": [
        "learnHi[1]",
        "Learn Hi",
        0
      ],
      "obj-6": [
        "loOn",
        "Lo on",
        0
      ],
      "obj-62": [
        "ctlCC",
        "Tone CC",
        0
      ],
      "obj-64": [
        "ctlCenter",
        "Center",
        0
      ],
      "obj-65": [
        "ctlRange",
        "Range",
        0
      ],
      "obj-7": [
        "loNote",
        "Low",
        0
      ],
      "obj-78": [
        "ccOn",
        "CC on",
        0
      ],
      "obj-8": [
        "learnLo",
        "Hi on",
        0
      ],
      "obj-9": [
        "hiOn",
        "High",
        0
      ],
      "parameterbanks": {
        "0": {
          "index": 0,
          "name": "",
          "parameters": [
            "-",
            "-",
            "-",
            "-",
            "-",
            "-",
            "-",
            "-"
          ],
          "buttons": [
            "-",
            "-",
            "-",
            "-",
            "-",
            "-",
            "-",
            "-"
          ]
        }
      },
      "inherited_shortname": 1
    },
    "latency": 0,
    "is_mpe": 0,
    "external_mpe_tuning_enabled": 0,
    "minimum_live_version": "",
    "minimum_max_version": "",
    "platform_compatibility": 0,
    "project": {
      "version": 1,
      "creationdate": 3590052786,
      "modificationdate": 3590052786,
      "viewrect": [
        0.0,
        0.0,
        300.0,
        500.0
      ],
      "autoorganize": 1,
      "hideprojectwindow": 1,
      "showdependencies": 1,
      "autolocalize": 0,
      "contents": {
        "patchers": {}
      },
      "layout": {},
      "searchpath": {},
      "detailsvisible": 0,
      "amxdtype": 1835887981,
      "readonly": 0,
      "devpathtype": 0,
      "devpath": ".",
      "sortmode": 0,
      "viewmode": 0,
      "includepackages": 0
    },
    "autosave": 0,
    "styles": [
      {
        "name": "comment001",
        "default": {
          "fontface": [
            0
          ],
          "fontsize": [
            12.0
          ]
        },
        "parentstyle": "",
        "multi": 0
      }
    ],
    "saved_attribute_attributes": {
      "default_plcolor": {
        "expression": ""
      }
    },
    "oscreceiveudpport": 0
  }
}