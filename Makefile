# ==============================================================================
# Makefile dành cho MeerK40t
# Hỗ trợ cài đặt, chạy ứng dụng, kiểm thử, biên dịch ngôn ngữ và đóng gói bản build
# ==============================================================================

# Tự động ưu tiên virtualenv cục bộ (.venv) nếu tồn tại
VENV_PYTHON := .venv/Scripts/python.exe
ifeq ($(wildcard $(VENV_PYTHON)),$(VENV_PYTHON))
    PYTHON ?= $(VENV_PYTHON)
else
    PYTHON ?= python
endif


.PHONY: all help install install-all install-dev translate run run-nogui run-simpleui test lint format build-wheel build-exe clean

# Mục tiêu mặc định: Hiển thị bảng trợ giúp
all: help

help:
	@echo ======================================================================
	@echo                    HƯỚNG DẪN SỬ DỤNG MAKEFILE MEERK40T                
	@echo ======================================================================
	@echo Các lệnh cài đặt:
	@echo   make install         - Cài đặt dependencies cơ bản
	@echo   make install-all     - Cài đặt toàn bộ dependencies (GUI + mở rộng Windows)
	@echo   make install-dev     - Cài đặt công cụ phát triển (flake8, black, pytest...)
	@echo.
	@echo Các lệnh thực thi ^& biên dịch ngôn ngữ:
	@echo   make translate       - Biên dịch các file ngôn ngữ (.po -^> .mo)
	@echo   make run             - Chạy ứng dụng giao diện đồ họa đầy đủ (GUI)
	@echo   make run-nogui       - Chạy ứng dụng ở chế độ dòng lệnh (console)
	@echo   make run-simpleui    - Chạy ứng dụng với giao diện đơn giản (Simple UI)
	@echo.
	@echo Các lệnh kiểm thử ^& chất lượng mã nguồn:
	@echo   make test            - Chạy bộ kiểm thử tự động (unit tests)
	@echo   make lint            - Kiểm tra cú pháp và quy chuẩn mã nguồn (flake8)
	@echo   make format          - Tự động định dạng mã nguồn (black)
	@echo.
	@echo Các lệnh đóng gói (Build):
	@echo   make build-wheel     - Build gói Python Wheel (.whl và .tar.gz)
	@echo   make build-exe       - Đóng gói thành file thực thi độc lập (.exe)
	@echo   make clean           - Dọn dẹp cache, file tạm, thư mục build/ và dist/
	@echo ======================================================================

# Cài đặt các gói phụ thuộc cơ bản
install:
	$(PYTHON) -m pip install --upgrade pip setuptools wheel
	$(PYTHON) -m pip install -r requirements.txt
	$(PYTHON) -m pip install -e .

# Cài đặt toàn bộ phụ thuộc (bao gồm tính năng mở rộng cho Windows: numba, potrace, barcode...)
install-all:
	$(PYTHON) -m pip install --upgrade pip setuptools wheel
	$(PYTHON) -m pip install -r requirements.txt
	-$(PYTHON) -m pip install -r requirements-optional-win.txt
	$(PYTHON) -m pip install -e .[all]

# Cài đặt công cụ phát triển và kiểm thử
install-dev:
	$(PYTHON) -m pip install -r requirements-dev.txt

# Biên dịch các file từ điển ngôn ngữ (.po sang .mo)
translate:
	$(PYTHON) translate.py

# Khởi chạy giao diện chính của MeerK40t
run: translate
	$(PYTHON) meerk40t.py

# Khởi chạy ở chế độ console (không mở GUI)
run-nogui: translate
	$(PYTHON) meerk40t.py --no-gui

# Khởi chạy với giao diện đơn giản (Simple UI)
run-simpleui: translate
	$(PYTHON) meerk40t.py --simpleui

# Chạy unit tests
test:
	$(PYTHON) -m unittest discover test -v

# Kiểm tra chất lượng mã nguồn
lint:
	flake8 meerk40t test

# Định dạng mã nguồn
format:
	black meerk40t test

# Build gói thư viện chuẩn Python (Wheel)
build-wheel: clean
	$(PYTHON) -m pip install build
	$(PYTHON) -m build

# Đóng gói thành file thực thi .exe độc lập bằng PyInstaller
# Sử dụng tools/build_exe.py để quản lý đổi tên file an toàn trước và sau khi build (kể cả khi lỗi)
build-exe: translate
	$(PYTHON) -m pip install pyinstaller
	$(PYTHON) tools/build_exe.py


# Dọn dẹp các thư mục và tập tin tạm sinh ra trong quá trình chạy và build
clean:
	$(PYTHON) tools/clean.py

