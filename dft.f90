module dft

  use utility, only: fp, pi

  implicit none

contains

  function matvecprod(A, x) result(y)
    real(fp), intent(in) :: x(:), A(:, :)
    real(fp) :: y(size(A, 1))
    integer :: i
    integer :: rows
    rows = size(A, 1)
    do i = 1, rows
      y(i) = sum(A(i, :)*x(:))
    end do
  end function matvecprod

  subroutine dft_TransMat(x, k, T)
    implicit none
    real(fp), intent(in)     :: x(:)
    real(fp), intent(out)    :: k(size(x))
    real(fp), intent(in out) :: T(size(x), size(x))

    integer :: N, i
    real(fp) :: om, dx

    N = size(x)
    dx = x(2) - x(1)
    om = 2*pi/(N*dx)

    ! Real basis: constant, then cosine/sine pairs for each positive mode.
    k(1) = 0.0_fp
    do i = 2, N, 2
      k(i) = i*om/2
      if (i + 1 <= N) then
        k(i + 1) = k(i)
      end if
    end do

    T(1, :) = 1.0_fp/N
    do i = 2, N, 2
      T(i, :) = (2.0_fp/N)*cos(k(i)*x)
      T(i + 1, :) = (2.0_fp/N)*sin(k(i)*x)
    end do

  end subroutine dft_TransMat

  subroutine dft_InvTransMat(x, k, Tinv)
    implicit none
    real(fp), intent(in)     :: x(:)
    real(fp), intent(in)     :: k(size(x))
    real(fp), intent(in out) :: Tinv(size(x), size(x))

    integer :: N, j

    N = size(x)

    Tinv(:, 1) = 1.0_fp
    do j = 2, N, 2
      Tinv(:, j) = cos(k(j)*x)
      Tinv(:, j + 1) = sin(k(j)*x)
    end do

  end subroutine dft_InvTransMat
end module dft
