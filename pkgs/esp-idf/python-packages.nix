# Versions based on
# https://dl.espressif.com/dl/esp-idf/espidf.constraints.v6.1.txt
#
# Versions found by running this script:
# ./pkgs/esp-idf/update-python-packages.sh v6.1
{
  fetchPypi,
  fetchurl,
  pythonPackages,
}:
with pythonPackages;
rec {
  idf-component-manager = buildPythonPackage rec {
    pname = "idf-component-manager";
    version = "3.1.2";
    pyproject = true;

    src = fetchPypi {
      inherit version;
      pname = "idf_component_manager";
      sha256 = "sha256-da2eRFLRv0K+oKd9cq9nlxTiuxR2J9kmzuEUEituM6A=";
    };

    build-system = [
      setuptools
    ];
    doCheck = false;

    propagatedBuildInputs = [
      jsonref

      pydantic
      pydantic-core
      pydantic-settings
      pyparsing

      pathvalidate
      psutil
      rich
      rich-click
      esp-pylib
      ruamel-yaml
      requests
      requests-file
      requests-toolbelt
      truststore
    ];

    meta = {
      homepage = "https://github.com/espressif/idf-component-manager";
    };
  };

  esp-coredump = buildPythonPackage rec {
    pname = "esp-coredump";
    version = "1.17.2";
    pyproject = true;

    src = fetchPypi {
      inherit version;
      pname = "esp_coredump";
      sha256 = "sha256-fA6zJATI+SvlCvDoOyuxSjPuxIC2ysdqhngw1WQHSmo=";
    };

    build-system = [
      setuptools
    ];

    doCheck = false;

    propagatedBuildInputs = [
      construct
      pygdbmi
      esptool
      esp-pylib
      click
      rich-click
      rich
    ];

    meta = {
      homepage = "https://github.com/espressif/esp-coredump";
    };
  };

  esptool = buildPythonPackage rec {
    pname = "esptool";
    version = "5.4.0";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-/XVlmNsKJsmXX6GFEbCGh8VL8s5zIu3oDPH1EX2tH1A=";
    };

    doCheck = false;

    propagatedBuildInputs = [
      intelhex
      bitstring
      cryptography
      pyserial
      reedsolo
      pyyaml
      rich-click
      click
      esp-pylib
      websockets
    ];

    # Replaces esptool.py import with .esptool.py-wrapped
    postInstall = ''
      sed -i "2s|^|\n\
      #fix import esptool patch\n\
      import importlib.util\n\
      import importlib.machinery\n\
      esptool_loader = importlib.machinery.SourceFileLoader(\"esptool\", \"$out/bin/.esptool.py-wrapped\")\n\
      esptool_spec = importlib.util.spec_from_loader(\"esptool\", esptool_loader)\n\
      esptool_module = importlib.util.module_from_spec(esptool_spec)\n\
      esptool_spec.loader.exec_module(esptool_module)\n\
      sys.modules[\"esptool\"] = esptool_module\n\
      #end of fix import esptool patch\n|" $out/bin/esp_rfc2217_server.py
    '';

    meta = {
      homepage = "https://github.com/espressif/esptool";
    };
  };

  esp-pylib = buildPythonPackage rec {
    pname = "esp-pylib";
    version = "1.1.5";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit version;
      pname = "esp_pylib";
      sha256 = "sha256-MAa8lWL5UmlX4J7oSIF0Y8Iv4QzPjqaLYVU5BsvAieA=";
    };

    doCheck = false;

    propagatedBuildInputs = [
      rich
    ];

    meta = {
      homepage = "https://pypi.org/project/esp-pylib/";
      description = "Python library for logging, utils and constants for Espressif Systems' Python projects";
    };
  };

  esp-idf-kconfig = buildPythonPackage rec {
    pname = "esp-idf-kconfig";
    version = "3.13.0";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit version;
      pname = "esp_idf_kconfig";
      sha256 = "sha256-t5uNygrqCH2Z7qrg5GJm95Hj8Z0BSV1dqV6aEeBIafw=";
    };

    doCheck = false;

    # esp-idf-kconfig >=3.9 gained an optional TUI menuconfig backend
    # (esp-pylib + textual) as a runtime dependency.
    propagatedBuildInputs = [
      rich
      pyparsing
      esp-pylib
      textual
    ];

    meta = {
      homepage = "https://github.com/espressif/esp-idf-kconfig";
    };
  };

  esp-idf-monitor = buildPythonPackage rec {
    pname = "esp-idf-monitor";
    version = "1.10.0";
    pyproject = true;

    src = fetchPypi {
      inherit version;
      pname = "esp_idf_monitor";
      sha256 = "sha256-ettpJ6/aqoVG+0uO7XptIMypsKqAz6WDnYAXG47XkPU=";
    };

    build-system = [
      setuptools
    ];

    doCheck = false;

    propagatedBuildInputs = [
      pyserial
      esp-coredump
      pyelftools
      esp-idf-panic-decoder
      esp-pylib
      rich
      rich-click
    ];

    meta = {
      homepage = "https://github.com/espressif/esp-idf-monitor";
    };
  };

  esp-idf-size = buildPythonPackage rec {
    pname = "esp-idf-size";
    version = "2.3.1";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit version;
      pname = "esp_idf_size";
      sha256 = "sha256-OU4waWUeCAgYhIdDLDi/+HqOWkkRWf+LSv1Hqzu5wZw=";
    };

    doCheck = false;

    # esp-idf-size >=2.3 gained rich-click (CLI) and esp-pylib as runtime
    # dependencies.
    propagatedBuildInputs = [
      rich
      pyyaml
      rich-click
      esp-pylib
    ];

    meta = {
      homepage = "https://github.com/espressif/esp-idf-size";
    };
  };

  esp-idf-nvs-partition-gen = buildPythonPackage rec {
    pname = "esp-idf-nvs-partition-gen";
    version = "0.1.9";
    pyproject = true;

    src = fetchPypi {
      inherit version;
      pname = "esp_idf_nvs_partition_gen";
      hash = "sha256-Q6ObVLJDGJ6REJpOmZaMhk8y4g4Ne5wzBSu9JqXxaQ8=";
    };

    build-system = [
      setuptools
    ];

    dependencies = [
      cryptography
    ];

    pythonImportsCheck = [ "esp_idf_nvs_partition_gen" ];

    meta = {
      homepage = "https://pypi.org/project/esp-idf-nvs-partition-gen/";
    };
  };

  pyclang = buildPythonPackage rec {
    pname = "pyclang";
    version = "0.7.0";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-s9SHh7tnSJFk0G7wNDMo1lGDG0Xw62fg/skiHvompfU=";
    };

    doCheck = false;

    # pyclang >=0.7 gained rich and esp-pylib as runtime dependencies.
    propagatedBuildInputs = [
      rich
      esp-pylib
    ];

    meta = {
      homepage = "https://pypi.org/project/pyclang/";
    };
  };

  freertos_gdb = buildPythonPackage rec {
    pname = "freertos-gdb";
    version = "1.0.4";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-lH/dlTX2PuZ89rX5zzpedHkqHvdVy+h6BzJ8rVFmkb8=";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/espressif/freertos-gdb";
    };
  };

  esp-idf-panic-decoder = buildPythonPackage rec {
    pname = "esp-idf-panic-decoder";
    version = "1.5.0";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit version;
      pname = "esp_idf_panic_decoder";
      sha256 = "sha256-ewk/ehul/f135CqWBIe1pDP2Dc2r84zJgXbykfw6iPs=";
    };

    doCheck = false;

    propagatedBuildInputs = [
      pyelftools
      pyparsing
    ];

    meta = {
      homepage = "https://github.com/espressif/esp-idf-panic-decoder";
    };
  };

  esp-idf-sbom = buildPythonPackage rec {
    pname = "esp-idf-sbom";
    version = "1.4.0";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit version;
      pname = "esp_idf_sbom";
      sha256 = "sha256-V4kjwdWPflxDJ4BhHQVasWPGQimpGhCAe6wAv7YIyEQ=";
    };

    doCheck = false;

    propagatedBuildInputs = [
      pyyaml
      schema
      license-expression
      rich
      pyparsing
      esp-pylib
      click
      rich-click
    ];

    meta = {
      homepage = "https://github.com/espressif/esp-idf-sbom";
      description = "SPDX SBOM generation tool for ESP-IDF projects";
    };
  };

  idf-drivers-gdb = buildPythonPackage rec {
    pname = "idf-drivers-gdb";
    version = "0.1.1";
    pyproject = true;

    build-system = [
      setuptools
    ];

    src = fetchPypi {
      inherit version;
      pname = "idf_drivers_gdb";
      sha256 = "sha256-3Jct+5sQawuIO0G7+MPtnL7oqXNnx17uq3csVzyEVcA=";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/espressif/idf-drivers-gdb";
      description = "Python GDB commands for debugging ESP-IDF drivers";
    };
  };

  esp-idf-diag = buildPythonPackage {
    pname = "esp-idf-diag";
    version = "0.2.0";
    pyproject = true;

    src = fetchurl {
      url = "https://github.com/espressif/esp-idf-diag/archive/refs/tags/v0.2.0.tar.gz";
      sha256 = "sha256-YEwLBYOveUl1xmZeZScXzY98PLCEWGgomt3t1WjJPJQ=";
    };

    build-system = [
      setuptools
    ];

    doCheck = false;

    propagatedBuildInputs = [
      pyyaml
      rich
    ];

    meta = {
      homepage = "https://github.com/espressif/esp-idf-diag";
      description = "Diagnostic tool for ESP-IDF";
    };
  };
}
