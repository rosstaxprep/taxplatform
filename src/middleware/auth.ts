import { Request, Response, NextFunction } from 'express';

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ status: 'error', error: { code: 'UNAUTHORIZED', message: 'Authentication required' } });
  // TODO: verify JWT
  next();
}

export function requireRole(...roles: string[]) {
  return (_req: Request, res: Response, next: NextFunction) => {
    // TODO: check req.user.role against roles
    next();
  };
}
