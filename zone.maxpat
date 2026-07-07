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
        "rect": [ 182.0, 288.0, 780.0, 540.0 ],
        "openinpresentation": 1,
        "boxes": [
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 30.0, 30.0, 45.0, 22.0 ],
                    "text": "midiin"
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 8,
                    "outlettype": [ "", "", "", "int", "int", "", "int", "" ],
                    "patching_rect": [ 30.0, 80.0, 62.0, 22.0 ],
                    "text": "midiparse"
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "" ],
                    "patching_rect": [ 30.0, 340.0, 90.0, 22.0 ],
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
                    "outlettype": [ "int", "" ],
                    "patching_rect": [ 200.0, 290.0, 66.0, 22.0 ],
                    "text": "midiformat"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 30.0, 430.0, 50.0, 22.0 ],
                    "text": "midiout"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "live.toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 400.0, 40.0, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 12.0, 30.0, 17.0, 17.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "off", "on" ],
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
                    "id": "obj-7",
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 440.0, 40.0, 60.0, 15.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 66.0, 30.0, 46.0, 15.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 48 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "loNote",
                            "parameter_modmode": 0,
                            "parameter_shortname": "Lo note",
                            "parameter_type": 1,
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "loNote"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "live.button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 520.0, 40.0, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 120.0, 30.0, 52.0, 18.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "off", "on" ],
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
                    "id": "obj-9",
                    "maxclass": "live.toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 400.0, 100.0, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 12.0, 112.0, 17.0, 17.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "off", "on" ],
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
                    "id": "obj-10",
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 440.0, 100.0, 60.0, 15.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 66.0, 112.0, 46.0, 15.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 72 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "hiNote",
                            "parameter_modmode": 0,
                            "parameter_shortname": "Hi note",
                            "parameter_type": 1,
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "hiNote"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "live.button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 520.0, 100.0, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 120.0, 112.0, 52.0, 18.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "off", "on" ],
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
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 400.0, 170.0, 90.0, 22.0 ],
                    "text": "prepend loon"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 440.0, 200.0, 70.0, 22.0 ],
                    "text": "prepend lo"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 520.0, 170.0, 100.0, 22.0 ],
                    "text": "prepend learnlo"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 400.0, 230.0, 90.0, 22.0 ],
                    "text": "prepend hion"
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 440.0, 260.0, 70.0, 22.0 ],
                    "text": "prepend hi"
                }
            },
            {
                "box": {
                    "id": "obj-17",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 520.0, 230.0, 100.0, 22.0 ],
                    "text": "prepend learnhi"
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 640.0, 200.0, 75.0, 22.0 ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 640.0, 260.0, 75.0, 22.0 ],
                    "text": "prepend set"
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "kslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 360.0, 300.0, 336.0, 53.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 12.0, 54.0, 420.0, 64.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "kslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 360.0, 370.0, 336.0, 53.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 12.0, 136.0, 420.0, 64.0 ]
                }
            },
            {
                "box": {
                    "fontsize": 11.0,
                    "id": "obj-30",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 40.0, 300.0, 30.0, 19.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 38.0, 31.0, 26.0, 19.0 ],
                    "text": "Lo",
                    "textcolor": [ 0.83, 0.83, 0.83, 1.0 ]
                }
            },
            {
                "box": {
                    "fontsize": 11.0,
                    "id": "obj-31",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 40.0, 370.0, 30.0, 19.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 38.0, 113.0, 26.0, 19.0 ],
                    "text": "Hi",
                    "textcolor": [ 0.83, 0.83, 0.83, 1.0 ]
                }
            },
            {
                "box": {
                    "fontsize": 11.0,
                    "id": "obj-32",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 190.0, 300.0, 240.0, 19.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 12.0, 170.0, 300.0, 19.0 ],
                    "text": "Zone — pass notes in [Lo, Hi)",
                    "textcolor": [ 0.62, 0.62, 0.62, 1.0 ]
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-2", 0 ],
                    "source": [ "obj-1", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-16", 0 ],
                    "source": [ "obj-10", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-17", 0 ],
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "source": [ "obj-12", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "source": [ "obj-13", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "source": [ "obj-15", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "source": [ "obj-16", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "source": [ "obj-17", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "source": [ "obj-18", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10", 0 ],
                    "source": [ "obj-19", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "source": [ "obj-2", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 6 ],
                    "source": [ "obj-2", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 5 ],
                    "source": [ "obj-2", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 4 ],
                    "source": [ "obj-2", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 3 ],
                    "source": [ "obj-2", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 2 ],
                    "source": [ "obj-2", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 1 ],
                    "source": [ "obj-2", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "source": [ "obj-20", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10", 0 ],
                    "source": [ "obj-21", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-18", 0 ],
                    "source": [ "obj-3", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-19", 0 ],
                    "source": [ "obj-3", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "source": [ "obj-3", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "source": [ "obj-4", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 0 ],
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-13", 0 ],
                    "source": [ "obj-7", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "source": [ "obj-8", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-15", 0 ],
                    "source": [ "obj-9", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-10": [ "hiNote", "Hi note", 0 ],
            "obj-11": [ "learnHi", "Learn Hi", 0 ],
            "obj-6": [ "loOn", "Lo on", 0 ],
            "obj-7": [ "loNote", "Lo note", 0 ],
            "obj-8": [ "learnLo", "Learn Lo", 0 ],
            "obj-9": [ "hiOn", "Hi on", 0 ],
            "parameterbanks": {
                "0": {
                    "index": 0,
                    "name": "",
                    "parameters": [ "-", "-", "-", "-", "-", "-", "-", "-" ],
                    "buttons": [ "-", "-", "-", "-", "-", "-", "-", "-" ]
                }
            },
            "inherited_shortname": 1
        },
        "autosave": 0,
        "oscreceiveudpport": 0
    }
}