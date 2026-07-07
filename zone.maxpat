{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 6,
      "revision": 0,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      80,
      80,
      820,
      560
    ],
    "openinpresentation": 1,
    "default_fontsize": 12.0,
    "default_fontface": 0,
    "default_fontname": "Arial",
    "gridonopen": 1,
    "gridsize": [
      15.0,
      15.0
    ],
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            30,
            30,
            45,
            22
          ],
          "text": "midiin",
          "outlettype": [
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 7,
          "patching_rect": [
            30,
            80,
            62,
            22
          ],
          "text": "midiparse",
          "outlettype": [
            "",
            "",
            "",
            "int",
            "int",
            "int",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 5,
          "patching_rect": [
            30,
            360,
            90,
            22
          ],
          "text": "js zone.js",
          "outlettype": [
            "",
            "",
            "",
            "",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-4",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            200,
            300,
            66,
            22
          ],
          "text": "midiformat",
          "outlettype": [
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            30,
            440,
            50,
            22
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
          "patching_rect": [
            400,
            40,
            24,
            24
          ],
          "outlettype": [
            "",
            ""
          ],
          "varname": "bypass",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            10,
            8,
            16,
            16
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "bypass",
              "parameter_shortname": "Bypass",
              "parameter_type": 2,
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_mmin": 0,
              "parameter_mmax": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-12",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            400,
            70,
            24,
            24
          ],
          "outlettype": [
            "",
            ""
          ],
          "varname": "mute",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            100,
            8,
            16,
            16
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "mute",
              "parameter_shortname": "Mute",
              "parameter_type": 2,
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_mmin": 0,
              "parameter_mmax": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-6",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            400,
            100,
            24,
            24
          ],
          "outlettype": [
            "",
            ""
          ],
          "varname": "loOn",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            10,
            32,
            16,
            16
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "loOn",
              "parameter_shortname": "Lo on",
              "parameter_type": 2,
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_mmin": 0,
              "parameter_mmax": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-7",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            440,
            100,
            60,
            18
          ],
          "outlettype": [
            "",
            "float"
          ],
          "varname": "loNote",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            48,
            32,
            42,
            17
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "loNote",
              "parameter_shortname": "Lo",
              "parameter_type": 1,
              "parameter_mmin": 0.0,
              "parameter_mmax": 127.0,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                48
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-8",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            400,
            130,
            24,
            24
          ],
          "outlettype": [
            "",
            ""
          ],
          "varname": "hiOn",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            108,
            32,
            16,
            16
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "hiOn",
              "parameter_shortname": "Hi on",
              "parameter_type": 2,
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_mmin": 0,
              "parameter_mmax": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-9",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            440,
            130,
            60,
            18
          ],
          "outlettype": [
            "",
            "float"
          ],
          "varname": "hiNote",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            146,
            32,
            42,
            17
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "hiNote",
              "parameter_shortname": "Hi",
              "parameter_type": 1,
              "parameter_mmin": 0.0,
              "parameter_mmax": 127.0,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                72
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-10",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            400,
            160,
            60,
            18
          ],
          "outlettype": [
            "",
            "float"
          ],
          "varname": "octave",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            44,
            57,
            42,
            17
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "octave",
              "parameter_shortname": "Octave",
              "parameter_type": 1,
              "parameter_mmin": -4.0,
              "parameter_mmax": 4.0,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                0
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-11",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            440,
            160,
            60,
            18
          ],
          "outlettype": [
            "",
            "float"
          ],
          "varname": "semitone",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            152,
            57,
            42,
            17
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "semitone",
              "parameter_shortname": "Tone",
              "parameter_type": 1,
              "parameter_mmin": -12.0,
              "parameter_mmax": 12.0,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                0
              ]
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-14",
          "maxclass": "live.tab",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            400,
            190,
            210,
            20
          ],
          "outlettype": [
            "",
            "",
            ""
          ],
          "varname": "mode",
          "parameter_enable": 1,
          "presentation": 1,
          "presentation_rect": [
            10,
            82,
            210,
            18
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "mode",
              "parameter_shortname": "Mode",
              "parameter_type": 2,
              "parameter_enum": [
                "Edit Lo",
                "Edit Hi",
                "Watch In",
                "Watch Out"
              ],
              "parameter_mmin": 0,
              "parameter_mmax": 3
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-16",
          "maxclass": "kslider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            400,
            230,
            340,
            56
          ],
          "outlettype": [
            "int",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            106,
            440,
            40
          ]
        }
      },
      {
        "box": {
          "id": "obj-40",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            30,
            309,
            120,
            18
          ],
          "text": "Bypass",
          "fontsize": 10.0,
          "textcolor": [
            0.83,
            0.83,
            0.83,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            30,
            9
          ]
        }
      },
      {
        "box": {
          "id": "obj-41",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            120,
            309,
            120,
            18
          ],
          "text": "Mute",
          "fontsize": 10.0,
          "textcolor": [
            0.83,
            0.83,
            0.83,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            120,
            9
          ]
        }
      },
      {
        "box": {
          "id": "obj-42",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            30,
            333,
            120,
            18
          ],
          "text": "Lo",
          "fontsize": 10.0,
          "textcolor": [
            0.83,
            0.83,
            0.83,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            30,
            33
          ]
        }
      },
      {
        "box": {
          "id": "obj-43",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            128,
            333,
            120,
            18
          ],
          "text": "Hi",
          "fontsize": 10.0,
          "textcolor": [
            0.83,
            0.83,
            0.83,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            128,
            33
          ]
        }
      },
      {
        "box": {
          "id": "obj-44",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            10,
            358,
            120,
            18
          ],
          "text": "Oct",
          "fontsize": 10.0,
          "textcolor": [
            0.83,
            0.83,
            0.83,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            58
          ]
        }
      },
      {
        "box": {
          "id": "obj-45",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            110,
            358,
            120,
            18
          ],
          "text": "Tone",
          "fontsize": 10.0,
          "textcolor": [
            0.83,
            0.83,
            0.83,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            110,
            58
          ]
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            400,
            170,
            110,
            22
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
          "patching_rect": [
            400,
            196,
            110,
            22
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
          "patching_rect": [
            400,
            222,
            110,
            22
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
          "patching_rect": [
            400,
            248,
            110,
            22
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
          "patching_rect": [
            400,
            274,
            110,
            22
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
          "patching_rect": [
            400,
            300,
            110,
            22
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
          "patching_rect": [
            400,
            326,
            110,
            22
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
          "patching_rect": [
            400,
            352,
            110,
            22
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
          "patching_rect": [
            400,
            378,
            110,
            22
          ],
          "text": "prepend moded"
        }
      },
      {
        "box": {
          "id": "obj-29",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            400,
            404,
            110,
            22
          ],
          "text": "prepend kbd"
        }
      },
      {
        "box": {
          "id": "obj-31",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            640,
            100,
            75,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-32",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            640,
            140,
            75,
            22
          ],
          "text": "prepend set"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-1",
            0
          ],
          "destination": [
            "obj-2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
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
            "obj-2",
            1
          ],
          "destination": [
            "obj-4",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            2
          ],
          "destination": [
            "obj-4",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            3
          ],
          "destination": [
            "obj-4",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            4
          ],
          "destination": [
            "obj-4",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            5
          ],
          "destination": [
            "obj-4",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            6
          ],
          "destination": [
            "obj-4",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-3",
            0
          ],
          "destination": [
            "obj-5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-4",
            0
          ],
          "destination": [
            "obj-5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-6",
            0
          ],
          "destination": [
            "obj-20",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-20",
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
            "obj-7",
            0
          ],
          "destination": [
            "obj-21",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-21",
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
            "obj-8",
            0
          ],
          "destination": [
            "obj-22",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-22",
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
            "obj-9",
            0
          ],
          "destination": [
            "obj-23",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-23",
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
            "obj-10",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-24",
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
            "obj-11",
            0
          ],
          "destination": [
            "obj-25",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-25",
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
            "obj-12",
            0
          ],
          "destination": [
            "obj-26",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-26",
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
            "obj-13",
            0
          ],
          "destination": [
            "obj-27",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-27",
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
            "obj-14",
            0
          ],
          "destination": [
            "obj-28",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-28",
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
            "obj-16",
            0
          ],
          "destination": [
            "obj-29",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-29",
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
            1
          ],
          "destination": [
            "obj-31",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-31",
            0
          ],
          "destination": [
            "obj-7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-3",
            2
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-32",
            0
          ],
          "destination": [
            "obj-9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-3",
            3
          ],
          "destination": [
            "obj-16",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-3",
            4
          ],
          "destination": [
            "obj-14",
            0
          ]
        }
      }
    ]
  }
}