import { h } from '@stencil/core';
import { JSXBase } from '@stencil/core/internal';

interface ResponsiveImgProps extends JSXBase.ImgHTMLAttributes<HTMLImageElement> {
  path: string;

  name: string;

  type?: string;

  dimensions: string;

  fallback?: boolean;
}

const ResponsiveImage = ({
  path,
  name,
  type = 'png',
  alt,
  dimensions,
  fallback = true,
  ...props
}: ResponsiveImgProps) => {
  !props.loading ? (props.loading = 'lazy') : '';
  return (
    <picture>
      <source type="image/webp" src={`${path}${name}@2x.webp 2x`} />
      <source type="image/webp" src={`${path}${name}.webp 1x`} />
      <source type="image/png" src={`${path}${name}@2x.${type} 2x`} />
      <source type="image/png" src={`${path}${name}.${type} 1x`} />
      <img
        {...props}
        alt={alt}
        src={`${path}${name}.${type}`}
        width={dimensions.split('x')[0]}
        height={dimensions.split('x')[1]}
      />
    </picture>
  );
};

export default ResponsiveImage;
