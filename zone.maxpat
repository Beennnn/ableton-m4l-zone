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
      780,
      540
    ],
    "openinpresentation": 0,
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
          "numoutlets": 3,
          "patching_rect": [
            30,
            340,
            90,
            22
          ],
          "text": "js zone.js",
          "outlettype": [
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
            290,
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
            430,
            50,
            22
          ],
          "text": "midiout"
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
            40,
            24,
            24
          ],
          "outlettype": [
            "",
            ""
          ],
          "varname": "loOn",
          "parameter_enable": 1,
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
            40,
            60,
            22
          ],
          "outlettype": [
            "",
            "float"
          ],
          "varname": "loNote",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "loNote",
              "parameter_shortname": "Lo note",
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
          "maxclass": "live.button",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            520,
            40,
            24,
            24
          ],
          "outlettype": [
            "bang"
          ],
          "varname": "learnLo",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "learnLo",
              "parameter_shortname": "Learn Lo"
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-9",
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
          "varname": "hiOn",
          "parameter_enable": 1,
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
          "id": "obj-10",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            440,
            100,
            60,
            22
          ],
          "outlettype": [
            "",
            "float"
          ],
          "varname": "hiNote",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "hiNote",
              "parameter_shortname": "Hi note",
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
          "id": "obj-11",
          "maxclass": "live.button",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            520,
            100,
            24,
            24
          ],
          "outlettype": [
            "bang"
          ],
          "varname": "learnHi",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "learnHi",
              "parameter_shortname": "Learn Hi"
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-12",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            400,
            170,
            90,
            22
          ],
          "text": "prepend loon"
        }
      },
      {
        "box": {
          "id": "obj-13",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            440,
            200,
            70,
            22
          ],
          "text": "prepend lo"
        }
      },
      {
        "box": {
          "id": "obj-14",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            520,
            170,
            100,
            22
          ],
          "text": "prepend learnlo"
        }
      },
      {
        "box": {
          "id": "obj-15",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            400,
            230,
            90,
            22
          ],
          "text": "prepend hion"
        }
      },
      {
        "box": {
          "id": "obj-16",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            440,
            260,
            70,
            22
          ],
          "text": "prepend hi"
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            520,
            230,
            100,
            22
          ],
          "text": "prepend learnhi"
        }
      },
      {
        "box": {
          "id": "obj-18",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            640,
            200,
            75,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-19",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            640,
            260,
            75,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "kslider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            360,
            300,
            340,
            56
          ],
          "outlettype": [
            "int",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
          "maxclass": "kslider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            360,
            370,
            340,
            56
          ],
          "outlettype": [
            "int",
            "int"
          ]
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
            "obj-12",
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
            "obj-13",
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
            "obj-14",
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
            "obj-15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-15",
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
            "obj-16",
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
            "obj-17",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-17",
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
            "obj-18",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-18",
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
            "obj-19",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-19",
            0
          ],
          "destination": [
            "obj-10",
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
            "obj-7",
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
            "obj-10",
            0
          ]
        }
      }
    ]
  }
}