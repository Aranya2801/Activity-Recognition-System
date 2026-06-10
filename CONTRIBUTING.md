# Contributing to Activity Recognition System

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## How to Contribute

### Reporting Bugs

1. Search [existing issues](https://github.com/yourusername/Activity-Recognition-System/issues) first
2. Use the bug report template
3. Include: Python version, OS, reproduction steps, expected vs actual behavior, error logs

### Suggesting Features

1. Open a [feature request issue](https://github.com/yourusername/Activity-Recognition-System/issues/new)
2. Describe the use case and expected behavior
3. Discuss before implementing large features

### Pull Requests

1. **Fork** the repository
2. **Create a branch**: `git checkout -b feature/your-feature` or `fix/your-fix`
3. **Make changes** following the code style guidelines
4. **Add tests** — all new functionality must be tested
5. **Run the test suite**: `pytest tests/ --cov=src`
6. **Format code**: `black src/ tests/` and `isort src/ tests/`
7. **Commit**: Use [Conventional Commits](https://www.conventionalcommits.org/)
   ```
   feat: add YOLOv9 pose estimation
   fix: correct sensor window normalization
   docs: update deployment guide
   test: add fusion model tests
   ```
8. **Push** and open a Pull Request

## Development Setup

```bash
git clone https://github.com/yourusername/Activity-Recognition-System.git
cd Activity-Recognition-System
python -m venv venv && source venv/bin/activate
pip install -e ".[dev]"
pre-commit install
```

## Code Style

- **Black** (line length 100) for formatting
- **isort** for import ordering  
- **Type hints** required for all public functions
- **Docstrings** required (Google style) for all public classes and functions
- **No bare `except:`** — always catch specific exceptions

## Testing

- Unit tests in `tests/unit/`
- Integration tests in `tests/integration/`
- Minimum 80% coverage for new code
- Mark slow/GPU tests with `@pytest.mark.slow` / `@pytest.mark.gpu`

## Model Contributions

When adding new models:
1. Inherit from `BaseVideoModel` or implement the sensor model interface
2. Include a reference to the original paper
3. Provide benchmark results on at least one standard dataset
4. Add weight download instructions

## Documentation

- Update `README.md` if adding major features
- Add docstrings to all public APIs
- Update `CHANGELOG.md` for significant changes

## Review Process

- PRs require at least 1 approval from a maintainer
- CI must pass (lint, tests, build)
- Large PRs should be broken into smaller, focused changes
