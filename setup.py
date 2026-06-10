"""
Activity Recognition System — Setup Configuration
"""
from setuptools import setup, find_packages
from pathlib import Path

here = Path(__file__).parent
long_description = (here / "README.md").read_text(encoding="utf-8")

setup(
    name="activity-recognition-system",
    version="1.0.0",
    author="Activity Recognition System Contributors",
    author_email="ars@example.com",
    description=(
        "Production-grade multimodal Human Activity Recognition platform "
        "with real-time video analysis, sensor fusion, fall detection, "
        "AI coaching, and explainable AI."
    ),
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/Activity-Recognition-System",
    project_urls={
        "Bug Tracker": "https://github.com/yourusername/Activity-Recognition-System/issues",
        "Documentation": "https://github.com/yourusername/Activity-Recognition-System/docs",
        "Source": "https://github.com/yourusername/Activity-Recognition-System",
    },
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Science/Research",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Scientific/Engineering :: Artificial Intelligence",
        "Topic :: Scientific/Engineering :: Image Recognition",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
    package_dir={"": "."},
    packages=find_packages(exclude=["tests*", "docs*", "notebooks*"]),
    python_requires=">=3.10",
    install_requires=[
        "torch>=2.1.0",
        "torchvision>=0.16.0",
        "fastapi>=0.104.1",
        "uvicorn[standard]>=0.24.0",
        "streamlit>=1.28.2",
        "mlflow>=2.8.1",
        "numpy>=1.24.4",
        "pandas>=2.1.3",
        "opencv-python>=4.8.1",
        "mediapipe>=0.10.7",
        "sqlalchemy>=2.0.23",
        "redis>=5.0.1",
        "pydantic>=2.5.0",
        "structlog>=23.2.0",
        "shap>=0.43.0",
        "lime>=0.2.0.1",
    ],
    extras_require={
        "dev": [
            "pytest>=7.4.3",
            "pytest-asyncio>=0.21.1",
            "pytest-cov>=4.1.0",
            "pytest-mock>=3.12.0",
            "black>=23.11.0",
            "isort>=5.12.0",
            "flake8>=6.1.0",
            "mypy>=1.7.1",
            "pre-commit>=3.5.0",
        ],
        "gpu": [
            "onnxruntime-gpu>=1.16.3",
        ],
        "edge": [
            "onnx>=1.15.0",
            "onnxruntime>=1.16.3",
        ],
        "docs": [
            "mkdocs>=1.5.3",
            "mkdocs-material>=9.4.8",
        ],
    },
    entry_points={
        "console_scripts": [
            "ars-api=src.api.main:run",
            "ars-dashboard=src.dashboard.app:run",
            "ars-train=scripts.train_video_models:main",
            "ars-demo=scripts.demo_webcam:main",
            "ars-download=scripts.download_datasets:main",
        ],
    },
    include_package_data=True,
    package_data={
        "": [
            "configs/*.yaml",
            "assets/**/*",
        ],
    },
    zip_safe=False,
    keywords=[
        "human activity recognition",
        "HAR",
        "computer vision",
        "pose estimation",
        "deep learning",
        "multimodal",
        "transformer",
        "fall detection",
        "real-time",
        "edge AI",
    ],
)
