module.exports = {
  darkMode: false, // or 'media' or 'class'
  mode: "jit",
  plugins: [
      require('@tailwindcss/aspect-ratio'),
      require('@tailwindcss/forms'),
      require('@tailwindcss/line-clamp'),
      require('@tailwindcss/typography')
  ],
  content: [
    './src/**/*.{js,jsx,ts,tsx,vue}'
  ],
  theme: {
      borderWidth: {
          '0': "0",
          '1': '1px',
          '2': '2px',
          '3': '3px',
          '4': '4px',
          '6': '6px',
          '8': '8px',
          '10': '10px',
          '12': '12px'
      },
      boxShadow: {
          "sm": "0 1px 2px 0 rgba(0, 0, 0, 0.05)",
          "base": "0 2px 5px rgba(0, 0, 0, 0.1)",
          "md": "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)",
          "lg": "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)",
          "xl": "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)",
          "2xl": "0 25px 50px -12px rgba(0, 0, 0, 0.25)",
          "negative": "0 -1px 8px rgba(0, 0, 0 , 0.15)",
          "negative-xl": "0 -1px 20px rgba(0, 0, 0 , 0.15)"
      },
      extend: {
        cursor: {
          'zoom-in': 'zoom-in'
        },
          typography: {
              DEFAULT: {
                  css: {
                      h1: {
                          fontSize: '1.75rem',
                      },
                      "> ol > ul": {
                      'li > :first-child': {
                          marginTop: '0'
                      },
                    },
                  }
              },
              'lg': {
                css: {
                  h1: {
                    fontSize: '2.25rem',
                  },
                  "> ul, > ol": {
                      'li > :first-child': {
                          marginTop: '0'
                      },
                  }
                }
              },
              'xl': {
                  css: {
                      "> ol, > ul": {
                        'li > :first-child': {
                            marginTop: '0'
                        },
                      },
                    }
              }
          }
      },
      flex: {
          '1': '1 1 0%',
          'auto': '1 1 auto',
          'fit': '0 0 auto',
          'full': '1 1 auto',
          'half': '0 0 50%',
          'initial': '0 1 auto',
          'none': 'none',
          'quarter': '0 0 25%'
      },
      fontSize: {
          '3xs': ['8px', { lineHeight: '1.2' }],
          '2xs': ['10px', { lineHeight: '1.2' }],
          xs: ['12px', { lineHeight: '1.25' }],
          sm: ['14px', { lineHeight: '1.25' }],
          base: ['16px', { lineHeight: '1.25' }],
          lg: ['18px', { lineHeight: '1.3' }],
          xl: ['20px', { lineHeight: '1.3' }],
          '2xl': ['24px', { lineHeight: '1.25' }],
          '3xl': ['30px', { lineHeight: '1.25' }],
          '4xl': ['32px', { lineHeight: '1.25' }],
          '5xl': ['40px', { lineHeight: '1.2' }],
          '6xl': ['48px', { lineHeight: '1.2' }],
          '7xl': ['68px', { lineHeight: '1.15' }],
          '8xl': ['80px', { lineHeight: '1.15' }],
          '9xl': ['92px', { lineHeight: '1.1' }],
          '10xl': ['104px', { lineHeight: '1.1' }]
      },
      maxWidth: {
          '50': '50px',
          '100': '100px',
          '150': '150px',
          '200': '200px',
          '250': '250px',
          '300': '300px',
          '350': '350px',
          '400': '400px',
          '450': '450px',
          '500': '500px',
          '550': '550px',
          '600': '600px',
          '650': '650px',
          '700': '700px',
          '750': '750px',
          '800': '800px',
          '850': '850px',
          '900': '900px',
          '950': '950px',
          '1000': '1000px',
          '1050': '1050px',
          '1100': '1100px',
          '1150': '1150px',
          '1200': '1200px',
          '1250': '1250px',
          '1300': '1300px',
          '1350': '1350px',
          '1400': '1400px',
          '1450': '1450px',
          '1/10': '10%',
          '1/9': '12.2222222%',
          '1/6': '16.6666666%',
          '1/5': '20%',
          '1/4': '25%',
          '1/3': '33.3333333%',
          '2/5': '40%',
          '1/2': '50%',
          '2/3': '66.6666666%',
          '3/4': '75%',
          '4/5': '80%',
          '5/6': '83.3333333%',
          '8/9': '88.8888888%',
          '9/10': '90%',
          'full': '100%',
          'screen': '100vw'
      },
      screens: {
          's350': '350px',
          's400': '400px',
          's450': '450px',
          's550': '550px',
          's650': '650px',
          's750': '750px',
          's850': '850px',
          's950': '950px',
          's1050': '1050px',
          's1150': '1150px',
          's1250': '1250px',
          's1350': '1350px',
          's1450': '1450px',
          's1550': '1550px',
          's1650': '1650px',
          's1750': '1750px',
          's1850': '1850px',
          's1950': '1950px',
          's2050': '2050px',
          's2150': '2150px',
          's2250': '2250px',
          's2350': '2350px',
          's2450': '2450px',
          's2550': '2550px',
          's350m': {
              'max': '349px'
          },
          's450m': {
              'max': '449px'
          },
          's550m': {
              'max': '549px'
          },
          's650m': {
              'max': '649px'
          },
          's750m': {
              'max': '749px'
          },
          's850m': {
              'max': '849px'
          },
          's950m': {
              'max': '949px'
          },
          's1050m': {
              'max': '1049px'
          },
          's1150m': {
              'max': '1149px'
          },
          's1250m': {
              'max': '1249px'
          },
          's1350m': {
              'max': '1349px'
          },
          's1450m': {
              'max': '1449px'
          },
          's1550m': {
              'max': '1549px'
          },
          's1650m': {
              'max': '1649px'
          },
          's1750m': {
              'max': '1749px'
          },
          's1850m': {
              'max': '1849px'
          },
          's1950m': {
              'max': '1949px'
          },
          's2050m': {
              'max': '2049px'
          },
          's2150m': {
              'max': '2149px'
          },
          's2250m': {
              'max': '2249px'
          },
          's2350m': {
              'max': '2349px'
          },
          's2450m': {
              'max': '2449px'
          },
          's2550m': {
              'max': '2549px'
          }
      },
      zIndex: {
          '1': '1',
          '2': '2',
          '3': '3',
          '4': '4',
          '5': '5',
          '6': '6',
          '7': '7',
          '8': '8',
          '9': '9',
          '99': '99'
      }
  }
}