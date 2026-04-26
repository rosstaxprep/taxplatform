# Vercel Deployment Instructions

## Step 1: Initialize Git Repository

```bash
cd /home/ubuntu/primeweb
git init
git add .
git commit -m "Initial commit: PrimeWeb production blueprint"
```

## Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Create repository: `primeweb-blueprint`
3. Set as public (for team access)

## Step 3: Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/primeweb-blueprint.git
git branch -M main
git push -u origin main
```

## Step 4: Deploy to Vercel

### Option A: Using Vercel CLI

```bash
npm install -g vercel
vercel --prod
```

### Option B: Using Vercel Dashboard

1. Go to https://vercel.com/dashboard
2. Click "New Project"
3. Select GitHub repository: `primeweb-blueprint`
4. Configure:
   - Framework: None (Static)
   - Build Command: (leave empty)
   - Output Directory: (leave empty)
5. Click "Deploy"

### Option C: Using GitHub Integration

1. Go to https://vercel.com/new
2. Connect GitHub account
3. Select `primeweb-blueprint` repository
4. Click "Import"
5. Click "Deploy"

## Step 5: Configure Custom Domain (Optional)

1. In Vercel dashboard, go to Settings → Domains
2. Add custom domain: `primeweb.rosstaxsoftware.com`
3. Follow DNS configuration instructions
4. Point DNS to Vercel nameservers

## Step 6: Verify Deployment

- Visit: https://primeweb-blueprint.vercel.app (default)
- Or: https://primeweb.rosstaxsoftware.com (custom domain)
- All documentation should be accessible

## Environment Variables

No environment variables needed for static site deployment.

## Monitoring

- Vercel automatically monitors deployment
- Check deployment logs in Vercel dashboard
- Enable analytics for traffic monitoring

## Continuous Deployment

- Any push to `main` branch automatically deploys
- Vercel creates preview URLs for pull requests
- Rollback available in deployment history

## Support

For issues, contact:
- Vercel Support: https://vercel.com/support
- Project Owner: condre@rosstaxsoftware.com
