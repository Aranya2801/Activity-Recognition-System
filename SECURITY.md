# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x.x   | ✅ Yes    |
| < 1.0   | ❌ No     |

## Reporting a Vulnerability

**Do NOT open a public issue for security vulnerabilities.**

Please email security@yourdomain.com with:
1. Description of the vulnerability
2. Steps to reproduce
3. Potential impact
4. Suggested fix (if any)

We will respond within 48 hours and provide a fix timeline.

## Security Measures

- All API inputs validated with Pydantic
- JWT authentication with configurable expiry
- Rate limiting on all public endpoints
- SQL injection prevention via SQLAlchemy ORM
- Secrets stored in environment variables, never in code
- Docker images run as non-root users
- Regular dependency updates via Dependabot
- Bandit security scanning in CI pipeline
- Trivy vulnerability scanning on Docker images
