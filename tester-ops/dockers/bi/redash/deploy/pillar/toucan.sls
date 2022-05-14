apache:
  public_access: True

python_apps:
  toucan:
    user: ocdskit-web
    git:
      url: https://github.com/open-contracting/toucan.git
      branch: main
      target: ocdskit-web
    django:
      app: ocdstoucan
      compilemessages: True
      env:
        ALLOWED_HOSTS: toucan.open-contracting.org
        FATHOM_ANALYTICS_DOMAIN: kite.open-contracting.org
        FATHOM_ANALYTICS_ID: UECNCPJN
        GOOGLE_ANALYTICS_ID: UA-35677147-3
    apache:
      configuration: django
      servername: toucan.open-contracting.org
    uwsgi:
      configuration: django

ssh:
  root:
    # Centro de Desarrollo Sostenible
    # Andrés
    - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCu9Dlp1UdtTUIxLUu3UGKEgrP3nKILKlRcheotO17SlJ2DFPne6AF++dJhLtiBXcS72l60MZZs02qrMt8NY6/hve88wrngrQHHkMEcF606gR1tXgKM6Q6vxJ78owzeSC6sqrKtLpyUdvIMl2wxIiHxEkkwvC5a4ngkgbx3wmszs0YxfX3v+q6vVRqio/QRQdWbHzf3igxi/uK4rfgC4vPFo1+DTBSZFfhd2gn24zV4c+Ab6UYGaetXHE6F5Yl7eHhpyhMm9/T4c2IZ8hS0zlYpsDZua4hBOA2viMmmna9H37L+nLzUgRq1mzBRupz67TxFip5g2vVe67UPFAu2dpmUHB7czgZLUcFYpiwqWuUnkeuXNIl3JdvGdO4l9LgzHC3b+YJG7E+LyhwgUl7udGRTkiyejFnESrE2eHP9iG6/wkxPBfkTJEx5RMU0JZex7bcnF625KRyZyss6qAcvdup8qi0o2wvxa3gQOkuSP9foa2HWzI/bwD2zGc9lvnAFPp9umYSfnq3beLghNElV5vhlt4vSWFBMHDrNArqoymZUOLoKOcf+L69H2bPrk0Q+IN+LqrNNdtQum5KMDu2XEexAuFWJPQYkJxK66n3PhqCtSIG06SCRzROVpgIaq/eltLUJ+mZljyfuP7lGhKscL39w3LYdi3woIhgSlLUt7+8ItQ==
    # Natalia
    - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmgNU8QZQbV5bucue2RXRdGvlR0fHfa3qtJSQaMCgFSxIGgLD8hvqCVQKz9xX5qopCY/KIWfty+pECYozMd7Ia9E3KKLxzXxsyOKP04EPLG7SKDy2swl+APNHHvNKXxOlMKt+EYyt9p3y1Ag1mdcEBF/xEcRYGibQzbEK0tvFexlegS6QvtLSYkkqmLOVAh8qScRERJ5XvKZbGYzkDmjHWRzgTIPKtJJKK/lKyg+fDDJP627/MzJS01Gl13RjqQ0nL5PyQXNfdGjzSRt9Jbuw/tntkxlEh83sMUb5OfgiElmGGdsrMMSGSIzgt+uXBXN4xHbyY5j7b/RK9nGjPwTg0e4TWof+hfPEDYoqAyoBsw5Db9s38h/tp1t0mLPXNkpKC6ZHklF/b/N91BG1j2+lfoNT3Ol8U+N/uGY153tvZa9F1qUWLN1JlAzvjAmlGStpxj7JIOZNDb8qF224qZB6ejE14a0VdPo89dhcP0FcgN//+5YREJ7fkT0sTgq0Y+ZM=
